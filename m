Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbXIEVk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbXIEVk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 17:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757087AbXIEVkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 17:40:47 -0400
Received: from panic.printk.net ([217.147.83.20]:46949 "EHLO panic.printk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757022AbXIEVkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 17:40:46 -0400
Subject: Re: [PATCH 0/2] Fix (improve) deadlock condition on module removal
	netfilter socket option removal
From: Jon Masters <jonathan@jonmasters.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Patrick McHardy <kaber@trash.net>,
       adam@yggdrasil.com, jcm@jonmasters.org,
       netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070905192744.GB25050@hmsreliant.think-freely.org>
References: <20070904202433.GA19083@hmsreliant.think-freely.org>
	 <46DEC9BF.9010807@trash.net>
	 <1189008806.10802.150.camel@localhost.localdomain>
	 <20070905170831.GA25050@hmsreliant.think-freely.org>
	 <1189014097.10802.174.camel@localhost.localdomain>
	 <20070905192744.GB25050@hmsreliant.think-freely.org>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Wed, 05 Sep 2007 17:39:11 -0400
Message-Id: <1189028351.12261.166.camel@jcmlaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-05 at 15:27 -0400, Neil Horman wrote:

> Now, I suppose its possible that I've not been looking at the right source tree
> when doing my work.  I've based my modprobe patch on this git tree:
> http://git.kernel.org/?p=linux/kernel/git/kyle/module-init-tools.git;a=summary
> If theres a newer one, if you could please point it out to me, I'd appreciate
> it.  If the functional equivalent of my second patch is already in there, then
> we just need my first patch to be good to go.

Neil, please test:

http://www.kernel.org/pub/linux/kernel/people/jcm/module-init-tools/module-init-tools-3.3-pre12.tar.bz2

Jon.


