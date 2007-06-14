Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbXFNXSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbXFNXSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 19:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbXFNXR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 19:17:58 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:46137
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbXFNXR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 19:17:57 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Bernd Paysan <bernd.paysan@gmx.de>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 19:17:58 -0400
User-Agent: KMail/1.9.6
Cc: "Alan Milnes" <alan@itfoundation.org.uk>, linux-kernel@vger.kernel.org
References: <466A3EC6.6030706@netone.net.tr> <b200add30706140708p41e943dbm5d14ba52a6e0ae75@mail.gmail.com> <200706141744.08408.bernd.paysan@gmx.de>
In-Reply-To: <200706141744.08408.bernd.paysan@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706141917.58824.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007 11:44:07 Bernd Paysan wrote:
> On Thursday 14 June 2007 16:08, Alan Milnes wrote:
> > Agreed - if you want to take my work you are welcome as long as you
> > contribute back your changes.  That's the deal that GPL2 enforces and
> > why it has been so successful.
>
> That may be a side effect of the GPL, but it's actually not how the GPLv2
> works (nor is it the intention). "Contribute back" means upstream. There's
> no such provision in the GPLv2, you contribute only downstream. And there
> are cases where you don't need to contribute at all.

And the Linux kernel community has been familiar with this situation all 
along.  It's the bargain the kernel developers struck with each other a 
decade and a half ago.

Now the FSF is coming along and being Darth Vader: "I am altering the bargain.  
Pray I don't alter it any further."

> I think this above explains fairly well the "misunderstandings" that are
> appearing here. The GPL is not reflective (tit-for-tat), it's transient. If
> there's a loop in the transient propagation, it becomes reflective through
> the loop, but not by itself. This was the case in GPLv1, is the case in
> GPLv2, and will be the case in GPLv3.

That's not specifically a limitation of the GPL, that's a limitation of 
copyright law which forms the basis of the GPL.  It covers distribution, not 
usage.

GPLv2 eliminates the case where I have a modified binary I contributed to, but 
can't see the source code of those modifications.  This has the pragmatic 
effect of greatly reducing forking in a project, such as the Emacs/Lucid 
Emacs fork that inspired the "Emacs license" that became GPLv1.

Rob
