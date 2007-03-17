Return-Path: <linux-kernel-owner+w=401wt.eu-S965565AbXCQOds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965565AbXCQOds (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 10:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965636AbXCQOdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 10:33:47 -0400
Received: from mail.gmx.net ([213.165.64.20]:44756 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965565AbXCQOdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 10:33:45 -0400
X-Provags-ID: V01U2FsdGVkX18cniMREqoc3ndKzc5SDc1ZvD88/CqJ77t26kch8b
	4+VRPuWv3SA+Ud
Subject: Re: [ck] Re: RSDL v0.31
From: Mike Galbraith <efault@gmx.de>
To: Mark Glines <mark-ck@glines.org>
Cc: David Lang <david.lang@digitalinsight.com>, Al Boldi <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org, ck@vds.kolivas.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicholas Miell <nmiell@comcast.net>
In-Reply-To: <20070317070906.1b84318c@chirp>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703170040.48316.kernel@kolivas.org>
	 <1174059299.7886.25.camel@Homer.simpson.net>
	 <200703170813.32594.kernel@kolivas.org>
	 <1174084207.7009.9.camel@Homer.simpson.net>
	 <1174105443.3144.4.camel@entropy>
	 <1174110965.7911.44.camel@Homer.simpson.net>
	 <1174112768.3144.8.camel@entropy> <20070317074506.GA13685@elte.hu>
	 <Pine.LNX.4.63.0703162326020.6015@qynat.qvtvafvgr.pbz>
	 <1174121187.8647.20.camel@Homer.simpson.net>
	 <20070317070906.1b84318c@chirp>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 15:33:41 +0100
Message-Id: <1174142021.7614.10.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-17 at 07:09 -0700, Mark Glines wrote:

> I don't suppose you can be a bit more specific, and define how much CPU
> constitutes a "substantial quantity"?  It looks to me like X already got
> about half of a CPU.
> 
> >  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
> > 6599 root      26   0  174m  30m 8028 R   51  3.1   7:08.70 0 Xorg
> 

This is a snippet from a hacked up by me version of RSDL.30, not stock.

	-Mike

