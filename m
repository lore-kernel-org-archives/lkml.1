Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbYGVNLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbYGVNLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYGVNLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:11:44 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:51542 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYGVNLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:11:44 -0400
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Message-Id: <9D2D9C95-C2B7-408C-BDA1-89B7748F6977@freescale.com>
From: Kumar Gala <kumar.gala@freescale.com>
To: benh@kernel.crashing.org
In-Reply-To: <1216711931.11027.193.camel@pasglop>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [git pull] Please pull from powerpc.git merge branch
Date: Tue, 22 Jul 2008 08:11:25 -0500
References: <1216711931.11027.193.camel@pasglop>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 22, 2008, at 2:32 AM, Benjamin Herrenschmidt wrote:

> Hi Linus !
>
> Here's the second batch of powerpc updates. I should have a last one
> before the end of the merge window for things that are stealing  
> dealing
> with conflicts or dependencies but we are getting there.
>
> So please pull from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge
>
> Hopefully this one shouldn't whack the main Makefile :-)
>
> Note a couple of fbdev updates. One is an offb change by me, this is
> a powerpc specific driver so that shouldn't affect anybody else, and
> one is the ps3 specific fbdev by Geoff, so again, there should be
> no collateral damage.
>
> Some drivers/net changes to freescale specific drivers are coming from
> Kumar's tree. Kumar, I merged them, however, shouldn't we have Jeff's
> ack on these things or is it ok as long as those are arch specific
> drivers and the changes boring ?

they had jeff's ack.  I just didn't update the commits, my bad and  
I'll fix that in the future.

- k

