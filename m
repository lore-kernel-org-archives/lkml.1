Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbXDIEVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbXDIEVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 00:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbXDIETX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 00:19:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:55645 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752826AbXDIETU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 00:19:20 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1//6alD3XH/RZBEiYLfD6ISNyly3Jjdf+Vym3aQRo
	1em3Xw494uYlcq
Subject: Re: Ten percent test
From: Mike Galbraith <efault@gmx.de>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <200704081357.43370.gene.heskett@gmail.com>
References: <200703290237.38777.kernel@kolivas.org>
	 <1176032450.6304.3.camel@Homer.simpson.net>
	 <1176033735.6404.2.camel@Homer.simpson.net>
	 <200704081357.43370.gene.heskett@gmail.com>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 06:19:16 +0200
Message-Id: <1176092356.6355.18.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-08 at 13:57 -0400, Gene Heskett wrote:
> On Sunday 08 April 2007, Mike Galbraith wrote:
> >On Sun, 2007-04-08 at 13:40 +0200, Mike Galbraith wrote:
> >> On Sun, 2007-04-08 at 07:33 -0400, Gene Heskett wrote:
> >> > That seems to be the killer loading here, building a kernel (make
> >> > -j3) doesn't seem to lag it all that bad.  One session of gzip -best
> >> > makes it fall plumb over though, which was a disappointment.
> >>
> >> Can you make a testcase that doesn't require amanda?
> >
> >Or at least send me a couple of 5 or 10 second top snapshots (which also
> >show CPU usage of sleeping tasks) while the system is misbehaving?
> >
> >	-Mike
> 
> With what monitor utility?

Top.

	-Mike

