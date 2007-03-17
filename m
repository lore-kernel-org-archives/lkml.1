Return-Path: <linux-kernel-owner+w=401wt.eu-S965030AbXCQKtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965030AbXCQKtd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 06:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965131AbXCQKtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 06:49:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:46323 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965030AbXCQKtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 06:49:32 -0400
X-Provags-ID: V01U2FsdGVkX1+G6qduYfaGjrpeR89XG3wdxUYp1dVpVJYHwvcCJj
	hbjj4O3fe3+aJV
Subject: Re: RSDL v0.31
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, Al Boldi <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1174125534.7734.2.camel@Homer.simpson.net>
References: <200703042335.26785.a1426z@gawab.com>
	 <20070317074506.GA13685@elte.hu> <87fy84i7nn.fsf@depni.sinp.msu.ru>
	 <200703172048.46267.kernel@kolivas.org>
	 <1174125534.7734.2.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 11:49:24 +0100
Message-Id: <1174128564.7996.9.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rocks and clubs at work (down boy <whack>, down i say!;).

This is .30 with some targeted unfairness. I seem to be making progress
toward beating it to a bloody but cooperative pulp.  It might be
possible to have my cake and eat it too.  Likely too ugly to live
though.

top - 11:35:50 up 57 min, 12 users,  load average: 5.20, 4.30, 2.57

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 6599 root      26   0  174m  30m 8028 R   51  3.1   7:08.70 0 Xorg
 7991 root      29   0 18196  14m 5188 R   47  1.4   0:55.70 0 amarok_libvisua
 7995 root      37   5  3720 2444  976 R   44  0.2   0:27.53 1 lame
 7993 root      37   5  3720 2448  976 R   40  0.2   0:46.60 1 lame

