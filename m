Return-Path: <linux-kernel-owner+w=401wt.eu-S1752445AbXDIEDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbXDIEDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 00:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbXDIEDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 00:03:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:44539 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752445AbXDIEDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 00:03:22 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1938xcCh0R3b4xshvtigl7E8/R8bm7qF6di7OrBqa
	uJUa2yLibXWSeI
Subject: Re: Ten percent test
From: Mike Galbraith <efault@gmx.de>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <200704081304.48033.gene.heskett@gmail.com>
References: <200703290237.38777.kernel@kolivas.org>
	 <20070408104125.GB11123@elte.hu> <20070408105849.GA15764@elte.hu>
	 <200704081304.48033.gene.heskett@gmail.com>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 06:03:16 +0200
Message-Id: <1176091396.6355.9.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-08 at 13:04 -0400, Gene Heskett wrote:
> On Sunday 08 April 2007, Ingo Molnar wrote:

> >and note that a year ago Mike did a larger patch too, not unlike his
> >current patch - but we hoped that his smaller change would be sufficient
> >- and nobody came along and said "i tested Mike's and the difference is
> >significant on my system".
> 
> May I suggest that while it may have been noticeable, it was 
> not 'significant', so we didn't sing praises and bow to mecca at the 
> time.

Actually, there was practically nil interest in testing.  We made a
couple of minor adjustments to the interactivity logic, and all went
quiet, so I didn't think it was enough of a problem to require more
intrusive countermeasures.

	-Mike

