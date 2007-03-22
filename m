Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbXCVEuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbXCVEuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 00:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932493AbXCVEuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 00:50:21 -0400
Received: from 1wt.eu ([62.212.114.60]:1339 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932469AbXCVEuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 00:50:20 -0400
Date: Thu, 22 Mar 2007 05:49:36 +0100
From: Willy Tarreau <w@1wt.eu>
To: Mike Galbraith <efault@gmx.de>
Cc: Paolo Ornati <ornati@fastwebnet.it>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>, Mark Lord <lkml@rtr.ca>,
       Al Boldi <a1426z@gawab.com>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RSDL v0.31
Message-ID: <20070322044935.GY943@1wt.eu>
References: <45FEB54A.3040602@rtr.ca> <1174321617.30876.69.camel@frg-rhel40-em64t-04> <45FEBBF5.9060002@rtr.ca> <1174322580.30876.72.camel@frg-rhel40-em64t-04> <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org> <20070320061152.GW943@1wt.eu> <1174377787.9756.21.camel@Homer.simpson.net> <1174489064.5379.42.camel@Homer.simpson.net> <20070321161147.54c7a727@localhost> <1174496853.6441.2.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174496853.6441.2.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 06:07:33PM +0100, Mike Galbraith wrote:
> On Wed, 2007-03-21 at 16:11 +0100, Paolo Ornati wrote:
> > On Wed, 21 Mar 2007 15:57:44 +0100
> > Mike Galbraith <efault@gmx.de> wrote:
> > 
> > > I was more than a bit surprised that mainline did this well, considering
> > > that the proggy was one someone posted long time ago to demonstrate
> > > starvation issues with the interactivity estimator.  (source not
> > > available unfortunately, was apparently still on my old PIII box along
> > > with the one Willy posted when I installed opensuse 10.2 on it.  damn.
> > > trivial thing though)
> > 
> > This one?  :)
> 
> No, but that one went to bit heaven too ;-)

Mike, if you need my old scheddos, I can resend it to you as well as to
any people working on the scheduler and asking for it. Although trivial,
I'm a bit reluctant to publish it to the whole world because I suspect
that distros based on older kernels are still vulnerable and the fixes
may not be easy. Anyway, it has absolutely no effect on non-interactive
schedulers.

Regards,
Willy

