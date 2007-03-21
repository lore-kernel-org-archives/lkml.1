Return-Path: <linux-kernel-owner+w=401wt.eu-S933056AbXCURGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056AbXCURGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 13:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933057AbXCURGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 13:06:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:42618 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933056AbXCURGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 13:06:31 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX185hRRPuMA5hTQ0maae4K8V5vg6Ki9MScZnPUa+jl
	302aIVQ+BjGNfT
Subject: Re: RSDL v0.31
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>, Mark Lord <lkml@rtr.ca>,
       Al Boldi <a1426z@gawab.com>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1174492966.16411.1.camel@twins>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703172048.46267.kernel@kolivas.org>
	 <1174125534.7734.2.camel@Homer.simpson.net>
	 <200703172355.30989.a1426z@gawab.com> <45FEB54A.3040602@rtr.ca>
	 <1174321617.30876.69.camel@frg-rhel40-em64t-04> <45FEBBF5.9060002@rtr.ca>
	 <1174322580.30876.72.camel@frg-rhel40-em64t-04>
	 <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org>
	 <20070320061152.GW943@1wt.eu>  <1174377787.9756.21.camel@Homer.simpson.net>
	 <1174489064.5379.42.camel@Homer.simpson.net>
	 <1174492966.16411.1.camel@twins>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 18:06:19 +0100
Message-Id: <1174496779.6441.1.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 17:02 +0100, Peter Zijlstra wrote:
> On Wed, 2007-03-21 at 15:57 +0100, Mike Galbraith wrote:
> 
> > 'f' is a progglet which sleeps a bit and burns a bit, duration depending
> > on argument given. 'sh' is a shell 100% hog.  In this scenario, the
> > argument was set such that 'f' used right at 50% cpu.  All are started
> > at the same time, and I froze top when the first 'f' reached 1:00.
> 
> May one enquire how much CPU the mythical 'f' uses when ran alone? Just
> to get a gauge for the numbers?

Right at 50%

	-Mike

(mythical?  i can send you the binary if you want)

