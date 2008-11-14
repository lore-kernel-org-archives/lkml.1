Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYKNTZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYKNTZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 14:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYKNTZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 14:25:46 -0500
Received: from vena.lwn.net ([206.168.112.25]:54502 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbYKNTZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 14:25:45 -0500
Date: Fri, 14 Nov 2008 12:25:43 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcupdate: move synchronize_sched() back to rcupdate.c
 V2
Message-ID: <20081114122543.0578bd5e@bike.lwn.net>
In-Reply-To: <491D2B16.8060000@cn.fujitsu.com>
References: <49129310.5000903@cn.fujitsu.com>
	<20081109005159.GM6917@linux.vnet.ibm.com>
	<4917A8E7.8060801@cn.fujitsu.com>
	<20081110184520.GC6685@linux.vnet.ibm.com>
	<4918D7E4.9030107@cn.fujitsu.com>
	<20081111010331.GF6685@linux.vnet.ibm.com>
	<491B9581.2080201@cn.fujitsu.com>
	<20081113173114.GA6788@linux.vnet.ibm.com>
	<491CCE58.1040701@cn.fujitsu.com>
	<20081114021152.GF6788@linux.vnet.ibm.com>
	<491D2B16.8060000@cn.fujitsu.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008 15:39:02 +0800
Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Paul E. McKenney wrote:

All seems good.  To answer Paul's original question:

> If so, please see attached patch and let me know what you think.
> Being too lazy to convert the cartoon to ASCII graphics, I simply
> left a URL to the .jpg on the LWN website.  Thus we need an ack/nack
> from Jon Corbet (CCed).

Of course I have no problem with the LWN links; they will remain stable.

If nobody objects, I'll drop this into my documentation tree.  Gotta
have *something* there, after all, or it might start to feel
neglected...

jon
