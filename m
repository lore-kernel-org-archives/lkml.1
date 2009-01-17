Return-Path: <linux-kernel-owner+w=401wt.eu-S1762861AbZAQPtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762861AbZAQPtw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 10:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762070AbZAQPtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 10:49:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:34261 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761968AbZAQPtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 10:49:41 -0500
Subject: Re: [git pull] scheduler fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1232197197.25807.2.camel@marge.simson.net>
References: <20090111144305.GA7154@elte.hu>
	 <20090114121521.197dfc5e.akpm@linux-foundation.org>
	 <1231964647.14825.59.camel@laptop>
	 <20090116204049.f4d6ef1c.akpm@linux-foundation.org>
	 <1232173776.7073.21.camel@marge.simson.net>
	 <1232186054.6813.48.camel@marge.simson.net>
	 <1232186877.14073.59.camel@laptop>
	 <1232188484.6813.85.camel@marge.simson.net>
	 <1232193617.14073.67.camel@laptop>
	 <1232194752.6273.5.camel@marge.simson.net>
	 <1232197197.25807.2.camel@marge.simson.net>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 16:49:23 +0100
Message-Id: <1232207363.5027.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-17 at 13:59 +0100, Mike Galbraith wrote:
> On Sat, 2009-01-17 at 13:19 +0100, Mike Galbraith wrote:
> 
> > Ouch, that doesn't look like it will be nice at all for interactivity.
> 
> Actually, it's not as bad as expected, merely lethargic slug.

Right, just ran the thing on my laptop and sluggish but 'usable' at load
>100 seems perfectly good to me.

