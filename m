Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbYKOUjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbYKOUjy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 15:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbYKOUjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 15:39:46 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55032 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbYKOUjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 15:39:45 -0500
Date: Sat, 15 Nov 2008 12:39:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcupdate: move synchronize_sched() back to rcupdate.c
	V2
Message-ID: <20081115203942.GA7108@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4917A8E7.8060801@cn.fujitsu.com> <20081110184520.GC6685@linux.vnet.ibm.com> <4918D7E4.9030107@cn.fujitsu.com> <20081111010331.GF6685@linux.vnet.ibm.com> <491B9581.2080201@cn.fujitsu.com> <20081113173114.GA6788@linux.vnet.ibm.com> <491CCE58.1040701@cn.fujitsu.com> <20081114021152.GF6788@linux.vnet.ibm.com> <491D2B16.8060000@cn.fujitsu.com> <20081114122543.0578bd5e@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114122543.0578bd5e@bike.lwn.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 12:25:43PM -0700, Jonathan Corbet wrote:
> On Fri, 14 Nov 2008 15:39:02 +0800
> Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
> > Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > 
> > Paul E. McKenney wrote:
> 
> All seems good.  To answer Paul's original question:
> 
> > If so, please see attached patch and let me know what you think.
> > Being too lazy to convert the cartoon to ASCII graphics, I simply
> > left a URL to the .jpg on the LWN website.  Thus we need an ack/nack
> > from Jon Corbet (CCed).
> 
> Of course I have no problem with the LWN links; they will remain stable.
> 
> If nobody objects, I'll drop this into my documentation tree.  Gotta
> have *something* there, after all, or it might start to feel
> neglected...

Works for me!

							Thanx, Paul
