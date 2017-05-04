# 作者：Raymond, Wenxian { .author}
# 审校：Wenxian { .proofread}
上一节我们介绍了纳维斯托克斯方程的连续方程形式，并且引进了导数$D$ 并称之为物质导数。对于一个流体粒子的任何量（例如速度，位置）$\mathbf{q}$ ，记作
$$
\frac{D\mathbf{q}}{Dt} = \frac{\partial \mathbf{q}}{\partial t} + \mathbf{u} \cdot \nabla \mathbf{q}
$$
我们指出，$D$ 仅仅是对量$\mathbf{q}$关于时间求导，这与该粒子所处的空间位置是**无关的**。

我们还介绍了物质导数$D$ 和一般意义上的导数$d$ （或者记作$\partial$） 的关系。这样我们很自然可以想到两种看待问题的方法：一种是我们考察研究对象$\mathbf{q}$ 相对时间和空间的变化（也即$\mathbf{q} \equiv \mathbf{q}(\mathbf{x}(t),t)$ ，其中$\mathbf{x}(t)$ 为空间向量）；另一种方法是我们跟随考察对象运动，只考虑该对象相对时间的变化（也即$\mathbf{q} \equiv \mathbf{q}(t)$ ）。 前一种方法统称为欧氏方法（Eulerial Methods），而后一种方法统称为拉氏方法（Lagrangian Methods）。

## 欧氏方法
在电影工业中，谈到欧氏方法通常指均匀网格的有限差分法（Finite Difference Method）。我们可以在空间中做网格剖分，其离散化**不随**时间变化而改变，流体块在网格中运动，如下图（图片出处[Micky2006]）：
![流体模拟的欧氏方法示意图，显示空间的网格分布](https://i.imgur.com/5IkFIlP.png)

## 拉氏方法
与欧氏方法相对，流体在拉氏方法中完全由物质粒子的集合所刻画（如下图）。对空间的离散化也随时间变化而变化；对于每个粒子，我们只关心其随时间变化的属性，而它所处空间的具体位置也是属性之一。
![enter image description here](https://i.imgur.com/A6SPV0v.png)

## 欧氏方法和拉氏方法的优劣
欧氏方法的优点在于在固定网格上求解连续方程（见上一章）较拉氏方法容易。由于更容易处理复杂的边界条件，我们通过有限差分可以很轻松地构建关于压强和速度线性方程组。同时很多在数值计算领域中分解（Factorize）、预处理（Precondition）和求解线性方程组的技巧都可以拿来用。在下一章我们可以看到，对于一般的流体，我们可以简单地解一个泊松方程来得到压强的分布。

欧氏方法需要对空间进行网格剖分，这在三维的情况下会导致随着网格剖分精度的提高运算量指数式暴涨（解决方法之一为[Fedkiw2004]，或者一些自适应网格方法）；流体整个被局限在网格中，使得在某些场景（比如模拟打翻容器流出的流体）中必须附加额外的网格。拉氏方法中，由于物质粒子自身即为离散化的基元，随着物质运动而运动，因此对于大范围运动流体的模拟较欧氏更有优势。同时，由于大部分欧氏方法需要在格子点上对各种变量进行插值，因此有可能会导致强烈的能量耗散。这种能量耗散会导致模拟的流体看起来很粘稠。拉氏方法则不存在这个问题。

## 欧氏方法举例
在电影工业中，得到大规模应用的欧氏方法由Jos Stam于2002年在一篇重量级文章《稳定流体》（Stable Fluids，[Stam2002]）中引入。
![Stable Fluids模拟的烟](https://i.imgur.com/TPhtlQd.png)
该方法将求解纳维-斯托克斯方程（见上一章）分为四步：

* 施加外力(external forces)：将重力等外力施加于流体格子；
* 导引(advection)：在格子的每一点根据当前速度进行向后追踪，估算流经该点的流体来源，然后将流体从来源处取到当前位置；
* 扩散(diffusion)：求解纳维-斯托克斯方程中的粘性项；
* 投影(projection)：构造并求解泊松方程将速度场中的散度去除，以实现流体的不可压性
 
我们在未来的章节中会对该方法的离散化过程和编程实现进行详细介绍。该方法曾经是电影工业中对流体进行物理模拟的不二之法，直到后来被数值耗散更小，更易于操控的粒子元胞法（Particle-in-Cell）等混合方法取代。
人们对此方法进行了大量改进。现今，使用非均匀、自适应网格等更高效的离散化策略已经开始普及，同时，数值计算领域中的一些方法，如多重网格（Multigrid）法，也被用于加速求解泊松方程。

在2016年，Chern等人发表了一篇文章《薛定谔的烟》[Chern2016]。他们将凝聚态物理中，用于求解超流体的非线性薛定谔方程（Gross-Pitaevskii方程）中的三阶项用求解连续方程的经典方法进行代替，成功地将两种方法结合，开发了一种没有数值耗散、同时高效求解其不可压性的欧氏方法。
![薛定谔的烟](https://i.imgur.com/qSvPzCL.jpg)
最上图为真实照片，瓶中是混合态的干冰，中间是模拟结果，最下面是对波函数进行可视化。
视频，《薛定谔的烟》：http://www.bilibili.com/video/av9595343/

## 拉氏方法举例
要说起电影工业中使用的拉氏方法，就不得不提平滑粒子动力学（Smoothed Particle Hydrodynamics，SPH）和它的一些改进。该方法最初是天体物理中用于模拟星系中的多体问题，之后被用于模拟流体。在SPH中，每个粒子都自带一个以其为中心的平滑函数，这些粒子通过这些平滑函数进行交互。

从另一个角度说，这等于是将各种变量（如密度、速度、压强）等构建于这些平滑函数上，然后只对这些基函数的系数进行计算。我们在下一章将具体介绍这个方法。

这类方法目前最广泛应用的是2009年Solenthaler等人开发的**预测校正不可压SPH** （PCISPH）[Solenthaler2009]，首次在这一类方法中实现了对压强的准确控制。
![预测校正不可压SPH](https://i.imgur.com/lMVJbhj.jpg)

PCISPH还存在时间步长过小的问题。在这之后，Macklin等人[Macklin2013]开发了**基于位置的流体**（Position Based Fluids），极大地提高了时间步长。目前，在3A游戏等对真实感要求较高的实时应用中已经开始普及。
![基于位置的流体](https://i.imgur.com/8PRSPrh.jpg)
上图是实时模拟并渲染的流体，下图是对用于模拟的粒子进行可视化。

在SPH这类方法中，除了三维意义上的完全离散化，也有另外一类方法，只模拟流体的表面。由于其计算复杂度比完全三维离散低一阶，因此常用于模拟非常精细的部分，像飞溅的水滴等。如2016年，大方等人在《只有表面的液体》一文中，提出了对速度场进行亥姆赫兹分解来实现不可压性的计算方式。
![只有表面的液体](https://i.imgur.com/ccjRllv.jpg)
视频《只有表面的流体》：http://www.bilibili.com/video/av9595406/


## 混合方法
在当今的电影工业中，应用最广泛的要数混合方法了。这类方法结合了欧氏方法易于处理不可压性和复杂边界条件的优点，以及拉氏方法求解导引项（即$\mathbf{u}\cdot\nabla \mathbf{u}$）数值耗散很小的特点。尤其是其中的粒子元胞法（Particle-In-Cell, PIC）、隐式粒子流体法（FLuids-Implicit-Particle, FLIP）以及最近，由蒋陈凡夫等人开发的仿射粒子元胞法（Affine Particle-In-Cell, APIC [Jiang2015]）为代表。
![APIC](https://i.imgur.com/ow7y3mm.jpg)
（用APIC方法模拟的水，该技术已应用于迪士尼和皮克斯最新的电影之中，如《海洋奇缘》、《鹬》等。动画电影《鹬》：https://www.bilibili.com/video/av6870485/  ）

除了水等不可压流体之外，混合方法也被用于实现一些其他效果。
![冻酸奶](https://i.imgur.com/vs1t3Fw.jpg)
如上，将仿射粒子元胞法（APIC）与物质点法（Material Point Method，MPM）结合，可以用于实现冻酸奶的模拟，以及如下图所示的岩浆的模拟：
![岩浆](https://i.imgur.com/HqgbqD7.jpg)

目前这类方法已经集成到最新版的特效软件中，如Houdini、RealFlow等等，我们在之后会对其进行详尽介绍，包括数学以及代码实现。
小编私货：

海洋的原声好好听的说(●ˇ∀ˇ●)
[海洋奇缘](http://www.bilibili.com/video/av6887732/?from=search&seid=2266597561733934659)

## Reference:

[Micky2006]:Kelager, Micky. "Lagrangian fluid dynamics using smoothed particle hydrodynamics." University of Copenhagen: Department of Computer Science (2006).

[Bridson2015]:Bridson, Robert. Fluid simulation for computer graphics. CRC Press, 2015.

[Fedkiw2004]: Losasso, Frank, Frédéric Gibou, and Ron Fedkiw. "Simulating water and smoke with an octree data structure." ACM Transactions on Graphics (TOG). Vol. 23. No. 3. ACM, 2004.

[Stam2002]: Stam, Jos. "Stable fluids." Proceedings of the 26th annual conference on Computer graphics and interactive techniques. ACM Press/Addison-Wesley Publishing Co., 1999.

[Chern2016]: Chern, Albert, et al. "Schrödinger's smoke." ACM Transactions on Graphics (TOG) 35.4 (2016): 77.

[Solenthaler2009]: Solenthaler, Barbara, and Renato Pajarola. "Predictive-corrective incompressible SPH." ACM transactions on graphics (TOG). Vol. 28. No. 3. ACM, 2009.

[Macklin2013]: Macklin, Miles, and Matthias Müller. "Position based fluids." ACM Transactions on Graphics (TOG) 32.4 (2013): 104.

[Jiang2015]: Jiang, Chenfanfu, et al. "The affine particle-in-cell method." ACM Transactions on Graphics (TOG) 34.4 (2015): 51.

