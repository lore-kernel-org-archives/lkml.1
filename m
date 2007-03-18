Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbXCRGS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbXCRGS3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 02:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbXCRGS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 02:18:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:50322 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752043AbXCRGS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 02:18:28 -0400
X-Provags-ID: V01U2FsdGVkX1+SqpgKucqSHgnIF0P9ygFPyk4KcJ4b/YcJCkdiVM
	pI5qhqv+8Hcgy/
Subject: Re: RSDL v0.31
From: Mike Galbraith <efault@gmx.de>
To: Al Boldi <a1426z@gawab.com>
Cc: Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org,
       Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200703172355.30989.a1426z@gawab.com>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703172048.46267.kernel@kolivas.org>
	 <1174125534.7734.2.camel@Homer.simpson.net>
	 <200703172355.30989.a1426z@gawab.com>
Content-Type: text/plain
Date: Sun, 18 Mar 2007 07:17:31 +0100
Message-Id: <1174198651.8199.44.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-17 at 23:55 +0300, Al Boldi wrote:

> Mike, I'm not saying RSDL is perfect, but v0.31 is by far better than 
> mainline.  Try this easy test:
> 
> startx with the vesa driver
> run reflect from the mesa5.0-demos
> load 5 cpu-hogs
> start moving the mouse
> 
> On my desktop, mainline completely breaks down, and no nicing may rescue.

(hmm.. i would think that _renicing_ X would help that)

> On RSDL, even without nicing, the desktop is at least useable.

So neither does a good job with this load.

	-Mike

