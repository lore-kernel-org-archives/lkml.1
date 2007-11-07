Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbXKGVMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbXKGVMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 16:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbXKGVMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 16:12:05 -0500
Received: from main.gmane.org ([80.91.229.2]:59213 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082AbXKGVME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 16:12:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: cecco <f.cecco77@tiscali.it>
Subject: Re: r8169:  NFG in 2.6.24-rc2
Date: Wed, 7 Nov 2007 21:03:17 +0000 (UTC)
Message-ID: <loom.20071107T205845-239@post.gmane.org>
References: <4731E2AB.5080703@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 151.49.127.202 (Mozilla/5.0 (X11; U; Linux i686; it; rv:1.8.1.8) Gecko/20071004 Iceweasel/2.0.0.8 (Debian-2.0.0.8-1))
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord <lkml <at> rtr.ca> writes:

> My ASUS board has one of these:

>Realtek Semiconductor Co., Ltd. RTL8111/8168B 
>PCI Express Gigabit
> With CONFIG_PCI_MSI=y, it also fails, and then isn't even 
detected lspci)
> on subsequent reboots.  A power cycle is required to get 
>it to show up again.
> Help?

Hello,

I have a asus a6t with RTL8111/8168B 
PCI Express Gigabit and I have had a similar 
problem.
PCI-MSI-edge seems to break this ethernet card.
My card has stopped to work, I have powered off
my notebook for hours, but I am not been lucky, 
because it has showed up only one time and then in 
next reboot with kernel  2.6.23 is disappeared again
(in this kernel there is not problem with this 
ethernet card ).
I have reflashed bios and  fortunately this card 
now works again. contacted one realtek developer, 
but he hasn't replied. I am been lucky 
to not send my notebook in repairing. 


It's very bad ! 



