Return-Path: <linux-kernel-owner+w=401wt.eu-S1763635AbYEFAPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763635AbYEFAPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbYEFAPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:15:11 -0400
Received: from www.tglx.de ([62.245.132.106]:43976 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629AbYEFAPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:15:10 -0400
Date: Tue, 6 May 2008 02:13:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Preempt-RT patch for 2.6.25
In-Reply-To: <1210025532.17132.82.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0805060106460.3318@apollo.tec.linutronix.de>
References: <3efb10970805021102n4d87f55eue723786281b06fcb@mail.gmail.com>  <1209753250.25628.34.camel@dd.thebigcorporation.com>  <Pine.LNX.4.58.0805021441340.10615@gandalf.stny.rr.com>  <1209754467.25628.42.camel@dd.thebigcorporation.com> 
 <Pine.LNX.4.58.0805021502040.10615@gandalf.stny.rr.com>  <1210003265.17132.6.camel@localhost.localdomain>  <Pine.LNX.4.58.0805051210410.23084@gandalf.stny.rr.com>  <1210004376.17132.14.camel@localhost.localdomain>  <Pine.LNX.4.58.0805051240520.25250@gandalf.stny.rr.com>
  <1210007084.17132.32.camel@localhost.localdomain>  <Pine.LNX.4.58.0805051426010.25250@gandalf.stny.rr.com>  <1210013938.17132.55.camel@localhost.localdomain>  <alpine.LFD.1.10.0805052107270.3318@apollo.tec.linutronix.de>
 <1210025532.17132.82.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008, Daniel Walker wrote:
> On Mon, 2008-05-05 at 23:01 +0200, Thomas Gleixner wrote:
> > We have been there before. kernel development does not follow the "we
> > want _now_" principle at all. Have you ever tried to yell at Linus "we
> > want XYZ _now_" ? If you decide to try it, please keep me on CC - I
> > want to enjoy the show.
> 
> Kernel development is "What is available now?" not what is avaiable in
> the future.

Interesting. I guess your universe is different from ours. According
to a well accredited dictionary:

development: the act or process of developing; growth; progress

Thanks,

	tglx
