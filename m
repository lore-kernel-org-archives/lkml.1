Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbYGGTSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbYGGTSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 15:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbYGGTS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 15:18:26 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58948 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbYGGTSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 15:18:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48726BF6.8020308@s5r6.in-berlin.de>
Date: Mon, 07 Jul 2008 21:18:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080614 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>,
       Oliver Neukum <oliver@neukum.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC] MAINTAINERS service, was: Re: alphabetic ordering of MAINTAINERS
References: <20080704063455.GA13999@digi.com>	<200807040852.27809.oliver@neukum.org>	<m3k5g1zv3u.fsf_-_@maximus.localdomain>	<20080704134426.GA32700@digi.com> <m37ic1zqqp.fsf@maximus.localdomain>	<487217E1.2040205@s5r6.in-berlin.de> <m3r6a5il2m.fsf@maximus.localdomain>
In-Reply-To: <m3r6a5il2m.fsf@maximus.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Stefan Richter <stefanr@s5r6.in-berlin.de> writes:
> 
>> We expect submissions to based on something more recent than 2.6.12.
> 
> Unfortunately we can't enforce that. People are working with old
> kernels (think of heavily-modified vendor trees), people send patches
> against old kernels, and we accept such patches (if it makes sense,
> of course).

If I get such patches and can apply them without /very/ much work, I 
gladly take them of course too.

But these are not the people anyway to which this maintainers lookup 
service would be targeted to.  As I see it, the people who want such a 
service are those who frequently send patches for various different 
areas of the kernel.  And these people don't work with 2.6.12.

(OTOH, occasional posters who don't even check if their patch would 
apply to a newer kernel too before they post it will probably also have 
less interest in figuring out the 100% optimum To: and Cc: list for 
their submission.  A "tell me a list of mail addresses; whatever you 
give me, I am not really interested in the particulars" service would 
not be an appropriate tool for these people.)

>> Your patch service however...
>> ...already exists.  Check the "L:" entries in MAINTAINERS.
> 
> Nice joke.

Not at all.  These are the forums where patches can be discussed in more 
detail because knowledgeable people are subscribed there.  You also have 
archives which you can query for patch postings and their discussions.

What you don't get is of course a unified "look and feel".  Some list 
archives are crap, some lists are subscriber-only, some kernel areas are 
not covered by a special list.  But the latter problem won't really go 
away with the proposed maintainers lookup service.
-- 
Stefan Richter
-=====-==--- -=== --===
http://arcgraph.de/sr/
