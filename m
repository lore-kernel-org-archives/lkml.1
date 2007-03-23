Return-Path: <linux-kernel-owner+w=401wt.eu-S933753AbXCWGMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753AbXCWGMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 02:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933679AbXCWGMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 02:12:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:42472 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751446AbXCWGL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 02:11:59 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/usLcEMCnutCXKRA5Lyy7cI1dbng+VK8Jj9oXJ8j
	INDa1i83TC87dS
Subject: Re: RSDL v0.31
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Willy Tarreau <w@1wt.eu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>, Mark Lord <lkml@rtr.ca>,
       Al Boldi <a1426z@gawab.com>, ck@vds.kolivas.org,
       Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200703231659.20291.kernel@kolivas.org>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703230950.51716.kernel@kolivas.org>
	 <1174624794.6554.64.camel@Homer.simpson.net>
	 <200703231659.20291.kernel@kolivas.org>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 07:11:51 +0100
Message-Id: <1174630311.7616.3.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 16:59 +1100, Con Kolivas wrote:

> The deadline mechanism is easy to hit and works. Try printk'ing it.

Hm.  I did (.30), and it didn't in an hours time doing this and that.
After I did the take your quota with you, it did kick in.  Lots.

	-Mike

