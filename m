Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbXCVHPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbXCVHPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 03:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbXCVHPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 03:15:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:40330 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753248AbXCVHPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 03:15:03 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+1znAVYyC1sjCNVtA22eiBmZnuhFdojTClXhj0cw
	6mYYSr0UE5bpXy
Subject: Re: RSDL v0.31
From: Mike Galbraith <efault@gmx.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Paolo Ornati <ornati@fastwebnet.it>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>, Mark Lord <lkml@rtr.ca>,
       Al Boldi <a1426z@gawab.com>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070322044935.GY943@1wt.eu>
References: <45FEB54A.3040602@rtr.ca>
	 <1174321617.30876.69.camel@frg-rhel40-em64t-04> <45FEBBF5.9060002@rtr.ca>
	 <1174322580.30876.72.camel@frg-rhel40-em64t-04>
	 <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org>
	 <20070320061152.GW943@1wt.eu> <1174377787.9756.21.camel@Homer.simpson.net>
	 <1174489064.5379.42.camel@Homer.simpson.net>
	 <20070321161147.54c7a727@localhost>
	 <1174496853.6441.2.camel@Homer.simpson.net>  <20070322044935.GY943@1wt.eu>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 08:14:59 +0100
Message-Id: <1174547699.7414.136.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 05:49 +0100, Willy Tarreau wrote:

> Mike, if you need my old scheddos, I can resend it to you as well as to
> any people working on the scheduler and asking for it. Although trivial,
> I'm a bit reluctant to publish it to the whole world because I suspect
> that distros based on older kernels are still vulnerable and the fixes
> may not be easy. Anyway, it has absolutely no effect on non-interactive
> schedulers.

Sure.  I'm really irked that I lost most of my collection of posted
exploits.  I prefer to test with the same widget the poster tested
with.  

(in this particular case, it's not _very_ important which one i test
with, i'm exploring my RSDL troubles with sleepers in general...
duration matters though, need to be fairly short/short burn.)

	-Mike

