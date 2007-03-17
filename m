Return-Path: <linux-kernel-owner+w=401wt.eu-S965521AbXCQNgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965521AbXCQNgl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 09:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965527AbXCQNgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 09:36:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:55036 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965521AbXCQNgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 09:36:40 -0400
X-Provags-ID: V01U2FsdGVkX19gWJhLMrVgTFFPdqxGQlzPV8QkSHCrOFimJppYRj
	YhPh2z/9RT9ihA
Subject: Re: RSDL v0.31
From: Mike Galbraith <efault@gmx.de>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, Al Boldi <a1426z@gawab.com>,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200703170805.59619.gene.heskett@gmail.com>
References: <200703042335.26785.a1426z@gawab.com>
	 <1174125534.7734.2.camel@Homer.simpson.net>
	 <1174128564.7996.9.camel@Homer.simpson.net>
	 <200703170805.59619.gene.heskett@gmail.com>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 14:36:30 +0100
Message-Id: <1174138590.7614.6.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-17 at 08:05 -0400, Gene Heskett wrote:
> >
> >top - 11:35:50 up 57 min, 12 users,  load average: 5.20, 4.30, 2.57
> >
> >  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
> > 6599 root      26   0  174m  30m 8028 R   51  3.1   7:08.70 0 Xorg
> > 7991 root      29   0 18196  14m 5188 R   47  1.4   0:55.70 0
> > amarok_libvisua 7995 root      37   5  3720 2444  976 R   44  0.2  
> > 0:27.53 1 lame 7993 root      37   5  3720 2448  976 R   40  0.2  
> > 0:46.60 1 lame
> 
> What X driver are you using Mike?  Are you on a builtin video chipset 
> using mobo shared memory?  I'm running the nvidia 9755 driver here with a 
> jaton nvidia 6200-256 card here, and YES I KNOW that taints the kernel, 
> but x is using on average, 1.3% of the cpu.

Xorg is using 50% cpu because I'm asking it to.

	-Mike

