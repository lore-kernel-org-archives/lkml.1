Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbYGGWiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbYGGWiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYGGWiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:38:00 -0400
Received: from OSB1387.piap.pl ([195.187.100.11]:60639 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040AbYGGWh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:37:59 -0400
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
	<m3r6a5il2m.fsf@maximus.localdomain>
	<48726BF6.8020308@s5r6.in-berlin.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 08 Jul 2008 00:37:55 +0200
In-Reply-To: <48726BF6.8020308@s5r6.in-berlin.de> (Stefan Richter's message of "Mon\, 07 Jul 2008 21\:18\:14 +0200")
Message-ID: <m37ibxl3r0.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

>> Unfortunately we can't enforce that. People are working with old
>> kernels (think of heavily-modified vendor trees), people send patches
>> against old kernels, and we accept such patches (if it makes sense,
>> of course).
>
> If I get such patches and can apply them without /very/ much work, I
> gladly take them of course too.
>
> But these are not the people anyway to which this maintainers lookup
> service would be targeted to.

They, too. Why not?

> As I see it, the people who want such a
> service are those who frequently send patches for various different
> areas of the kernel.

Sure, they too.

> (OTOH, occasional posters who don't even check if their patch would
> apply to a newer kernel too before they post it will probably also
> have less interest in figuring out the 100% optimum To: and Cc: list
> for their submission.

And less skills. Though they would manage a single patch submission
address I guess.

>  A "tell me a list of mail addresses; whatever
> you give me, I am not really interested in the particulars" service
> would not be an appropriate tool for these people.)

I think it would. Why not?

> Not at all.  These are the forums where patches can be discussed in
> more detail because knowledgeable people are subscribed there.  You
> also have archives which you can query for patch postings and their
> discussions.

Same here, except that it would be easier = "faster" and/or
"possible". "Faster" for regular kernel contributors and "possible"
for many occasional ones.

> What you don't get is of course a unified "look and feel".  Some list
> archives are crap, some lists are subscriber-only, some kernel areas
> are not covered by a special list.

Not the most important points IMHO but yes, that too.

> But the latter problem won't
> really go away with the proposed maintainers lookup service.

Well, I think it should. Why not?
I don't say we replace mailing lists, far from it.
I expect mailing lists to be subscribed to the service.

Come on, the theory looks good but the thing needs to be created and
_that_ may be the weak spot :-)
-- 
Krzysztof Halasa
