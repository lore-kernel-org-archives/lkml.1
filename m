Return-Path: <linux-kernel-owner+w=401wt.eu-S933114AbXCURHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbXCURHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 13:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933138AbXCURHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 13:07:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:50606 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933114AbXCURHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 13:07:37 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+kNRwhYmekpZuC5mYyxZPp2cgliUFVG20fpDxEDR
	xirOZtF0wexmcx
Subject: Re: RSDL v0.31
From: Mike Galbraith <efault@gmx.de>
To: Paolo Ornati <ornati@fastwebnet.it>
Cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>, Mark Lord <lkml@rtr.ca>,
       Al Boldi <a1426z@gawab.com>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Nicholas Miell <nmiell@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070321161147.54c7a727@localhost>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703172048.46267.kernel@kolivas.org>
	 <1174125534.7734.2.camel@Homer.simpson.net>
	 <200703172355.30989.a1426z@gawab.com> <45FEB54A.3040602@rtr.ca>
	 <1174321617.30876.69.camel@frg-rhel40-em64t-04> <45FEBBF5.9060002@rtr.ca>
	 <1174322580.30876.72.camel@frg-rhel40-em64t-04>
	 <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org>
	 <20070320061152.GW943@1wt.eu> <1174377787.9756.21.camel@Homer.simpson.net>
	 <1174489064.5379.42.camel@Homer.simpson.net>
	 <20070321161147.54c7a727@localhost>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 18:07:33 +0100
Message-Id: <1174496853.6441.2.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 16:11 +0100, Paolo Ornati wrote:
> On Wed, 21 Mar 2007 15:57:44 +0100
> Mike Galbraith <efault@gmx.de> wrote:
> 
> > I was more than a bit surprised that mainline did this well, considering
> > that the proggy was one someone posted long time ago to demonstrate
> > starvation issues with the interactivity estimator.  (source not
> > available unfortunately, was apparently still on my old PIII box along
> > with the one Willy posted when I installed opensuse 10.2 on it.  damn.
> > trivial thing though)
> 
> This one?  :)

No, but that one went to bit heaven too ;-)

	-Mike

