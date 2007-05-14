Return-Path: <linux-kernel-owner+w=401wt.eu-S1760645AbXENWzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645AbXENWzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbXENWzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:55:12 -0400
Received: from gw.goop.org ([64.81.55.164]:52401 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715AbXENWzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:55:10 -0400
Message-ID: <4648E8CB.2070308@goop.org>
Date: Mon, 14 May 2007 15:55:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [VOYAGER] fix build broken by shift to smp_ops
References: <1179158912.3703.47.camel@mulgrave.il.steeleye.com>	 <46489818.4000408@goop.org>	 <20070514125946.0f74221c.akpm@linux-foundation.org>	 <4648C062.5090704@goop.org>	 <20070514133745.5bfc34ac.akpm@linux-foundation.org>	 <1179176058.3703.85.camel@mulgrave.il.steeleye.com>	 <20070514140530.8e0491cf.akpm@linux-foundation.org>	 <4648D03F.4090407@goop.org>	 <20070514145158.ca5f6174.akpm@linux-foundation.org>	 <4648DBE4.9000903@goop.org> <1179181659.3703.99.camel@mulgrave.il.steeleye.com>
In-Reply-To: <1179181659.3703.99.camel@mulgrave.il.steeleye.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> Seriously, though, although I tolerate voyager breakage through the
> merge window, I actively try to clean it up and have a working voyager
> for the next release.  There's no real excuse for not fixing build
> breakage.  How it's done, I don't really care.  The only blocker for the
> two patch smp consolidation + voyager fix was Andi ... if he's relaxing
> that, then we can go that route.
>
> Until this is fixed, there are going to be -rc testers firing off build
> failure reports, which I think we'd all like to 

Sure.  I'm just surprised this is causing so much fuss, since I thought
we'd resolved it all last month.

    J
