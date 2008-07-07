Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbYGGSwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbYGGSwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbYGGSwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:52:06 -0400
Received: from khc.piap.pl ([195.187.100.11]:45918 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbYGGSwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:52:05 -0400
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Uwe =?iso-8859-2?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
       Oliver Neukum <oliver@neukum.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC] MAINTAINERS service, was: Re: alphabetic ordering of MAINTAINERS
References: <20080704063455.GA13999@digi.com>
	<200807040852.27809.oliver@neukum.org>
	<m3k5g1zv3u.fsf_-_@maximus.localdomain>
	<20080704134426.GA32700@digi.com> <m37ic1zqqp.fsf@maximus.localdomain>
	<487217E1.2040205@s5r6.in-berlin.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 07 Jul 2008 20:52:01 +0200
In-Reply-To: <487217E1.2040205@s5r6.in-berlin.de> (Stefan Richter's message of "Mon\, 07 Jul 2008 15\:19\:29 +0200")
Message-ID: <m3r6a5il2m.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

> We expect submissions to based on something more recent than 2.6.12.

Unfortunately we can't enforce that. People are working with old
kernels (think of heavily-modified vendor trees), people send patches
against old kernels, and we accept such patches (if it makes sense,
of course).

> Your patch service however...
> ...already exists.  Check the "L:" entries in MAINTAINERS.

Nice joke.
-- 
Krzysztof Halasa
