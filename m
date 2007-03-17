Return-Path: <linux-kernel-owner+w=401wt.eu-S1749667AbXCQUxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1749667AbXCQUxF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 16:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbXCQUxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 16:53:04 -0400
Received: from [212.12.190.140] ([212.12.190.140]:32896 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1749667AbXCQUxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 16:53:02 -0400
From: Al Boldi <a1426z@gawab.com>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: RSDL v0.31
Date: Sat, 17 Mar 2007 23:55:30 +0300
User-Agent: KMail/1.5
Cc: Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org,
       Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200703042335.26785.a1426z@gawab.com> <200703172048.46267.kernel@kolivas.org> <1174125534.7734.2.camel@Homer.simpson.net>
In-Reply-To: <1174125534.7734.2.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200703172355.30989.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Sat, 2007-03-17 at 20:48 +1100, Con Kolivas wrote:
> > The most frustrating part of a discussion of this nature on lkml is that
> > earlier information in a thread seems to be long forgotten after a few
> > days and all that is left is the one reporter having a problem.
>
> One?  I'm not the only person who reported regression.

Mike, I'm not saying RSDL is perfect, but v0.31 is by far better than 
mainline.  Try this easy test:

startx with the vesa driver
run reflect from the mesa5.0-demos
load 5 cpu-hogs
start moving the mouse

On my desktop, mainline completely breaks down, and no nicing may rescue.

On RSDL, even without nicing, the desktop is at least useable.

What we need is constructive criticism to improve the situation, either with 
mainline or with RSDL.  And for now RSDL is better.


Thanks!

--
Al

