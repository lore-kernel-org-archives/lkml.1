Return-Path: <linux-kernel-owner+w=401wt.eu-S1751749AbXDIRKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbXDIRKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 13:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbXDIRKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 13:10:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:41695 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751749AbXDIRK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 13:10:29 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+DY3QsfgeDi1ASg5B6zVO5qW1RLu1R7jNzbPhtrl
	1eYAjTkCuPw6Cv
Subject: Re: Ten percent test
From: Mike Galbraith <efault@gmx.de>
To: Rene Herman <rene.herman@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <461A2E39.8060106@gmail.com>
References: <200703290237.38777.kernel@kolivas.org>
	 <200704071423.47790.gene.heskett@gmail.com>
	 <20070407185220.GA31725@elte.hu>
	 <200704071630.25830.gene.heskett@gmail.com>
	 <20070408104125.GB11123@elte.hu>  <461939A4.2020305@gmail.com>
	 <1176092598.6355.22.camel@Homer.simpson.net>  <461A2E39.8060106@gmail.com>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 19:10:25 +0200
Message-Id: <1176138625.6109.69.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 14:14 +0200, Rene Herman wrote:

> This turned into an interactivity thing, and while interactivity is in 
> fact better for a large majority of testers, that isn't what Kolivas' 
> scheduler is about. It's about predictability and leaving the dead-end 
> road of these endlesss tweaks, which then break previous tweaks, rinse, 
> repeat.

To me, it's more than an interactivity thing.  It is also about reacting
to a dynamic environment, which the desktop is.  SD is not dynamic.

> It's unfortunate that Kolivas is having health problems currently, but I 
> certainly do hope that his scheduler finds its way into _a_ -rc1. He 
> said it was done...

Well, there I disagree with him quite strongly, but it's not my decision
what gets integrated into any tree but my own ;-)

	-Mike

