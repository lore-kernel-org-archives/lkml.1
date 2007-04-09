Return-Path: <linux-kernel-owner+w=401wt.eu-S1752985AbXDIF7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbXDIF7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 01:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbXDIF7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 01:59:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:49638 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752984AbXDIF7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 01:59:42 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/E2z0xm3vE0yXgdiVreh25xlVnT61BCdvoeHgJvQ
	pWJadiQrYBaL61
Subject: Re: Ten percent test
From: Mike Galbraith <efault@gmx.de>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <200704090009.02587.gene.heskett@gmail.com>
References: <200703290237.38777.kernel@kolivas.org>
	 <200704081304.48033.gene.heskett@gmail.com>
	 <1176091396.6355.9.camel@Homer.simpson.net>
	 <200704090009.02587.gene.heskett@gmail.com>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 07:59:39 +0200
Message-Id: <1176098379.6355.106.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 00:08 -0400, Gene Heskett wrote:
> On Monday 09 April 2007, Mike Galbraith wrote:
> >
> >
> >Actually, there was practically nil interest in testing.  We made a
> >couple of minor adjustments to the interactivity logic, and all went
> >quiet, so I didn't think it was enough of a problem to require more
> >intrusive countermeasures.
> >
> >	-Mike
> 
> Does one of these messages have a url so I can test the latest of your 
> patches for -rc6?  Or was the one Ingo sent the most recent?

No, my tree has a bugfix and some other adjustments that try to move the
balance closer to fair without sacrificing interactivity.

> Putting that url in your sig would be nice, and might result in its 
> getting a lot more exersize which should = more feedback.

When I get it cleaned up and better tested, I'll post again.  If you
want, I'll CC you... willing victims are a highly valued commodity :)

	-Mike

