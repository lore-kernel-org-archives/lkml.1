Return-Path: <linux-kernel-owner+w=401wt.eu-S933099AbXCMLqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbXCMLqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 07:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933127AbXCMLqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 07:46:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:37347 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933099AbXCMLqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 07:46:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+5JbZielG5icgNchRtKr4ksQxtdj1Ljv9qrqHGWt
	Ffl4w97ga1zsh7
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: Serge Belyshev <belyshev@depni.sinp.msu.ru>
Cc: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <87bqix5q18.fsf@depni.sinp.msu.ru>
References: <200703111457.17624.kernel@kolivas.org>
	 <1173778398.6810.21.camel@Homer.simpson.net>
	 <20070313093914.GA10533@elte.hu> <200703132106.08878.kernel@kolivas.org>
	 <1173785006.8561.19.camel@Homer.simpson.net>
	 <87bqix5q18.fsf@depni.sinp.msu.ru>
Content-Type: text/plain
Date: Tue, 13 Mar 2007 12:46:21 +0100
Message-Id: <1173786381.8561.22.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 14:41 +0300, Serge Belyshev wrote:
> Mike Galbraith <efault@gmx.de> writes:
> 
> [snip]
> > It seems to be a plain linear slowdown.  The lurchiness I'm experiencing
> > varies in intensity, and is impossible to quantify.  I see neither
> > lurchiness nor slowdown in mainline through -j8.
> >
> Whaa? make -j8 on mainline makes my desktop box completely useless.
> 
> Please reconsider your statement.

I'll do no such thing, and don't appreciate the insinuation.

	-Mike

