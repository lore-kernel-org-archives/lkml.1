Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbXEMIri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbXEMIri (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 04:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbXEMIra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 04:47:30 -0400
Received: from nile.gnat.com ([205.232.38.5]:40830 "EHLO nile.gnat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441AbXEMIr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 04:47:29 -0400
X-Greylist: delayed 1850 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 May 2007 04:47:29 EDT
Message-ID: <4646C8FA.2090602@adacore.com>
Date: Sun, 13 May 2007 04:14:50 -0400
From: Robert Dewar <dewar@adacore.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: James Cloos <cloos@jhcloos.com>
CC: LKML <linux-kernel@vger.kernel.org>, discuss@x86-64.org,
       trivial@kernel.org, Andi Kleen <ak@suse.de>,
       Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [discuss] [PATCH] spelling fixes: arch/x86_64/
References: <4644C783.3090805@simon.arlott.org.uk>	<200705121825.26430.ak@suse.de> <m3abw9a4w9.fsf@lugabout.jhcloos.org>
In-Reply-To: <m3abw9a4w9.fsf@lugabout.jhcloos.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Cloos wrote:
>>>>>> "Andi" == Andi Kleen <ak@suse.de> writes:
> 
>>> -		/* Reenable any watchpoints before delivering the
>>> +		/* Re-enable any watchpoints before delivering the
> 
> Andi> reenable gets >140k google hits so it seems to be an really
> Andi> used word.

Well you will find extensive "misuse" of all the re-e* words in
english, but all should be hyphenated. Moreover, there is no
license in english to just create new such words, you cannot
re-entertain your guests for example. In practice we do allow
creation of new re-e* words, as in re-execute, and that's
probably ok in techno-jargon-speak.

But re-enable is an old and well used word, reenable is not,
and I see no reason to encourage the latter incorrect use,
since it is harder to read (double e after r at the start
of the word is almost always a long e).

Note that in google, you always want to hyphenate. reenable
will catch only the misuses, re-enable will catch both.
> 
> Essentially all commonly used English words which start out with hyphens
> loose them over time.  It starts out with typos and progresses until the
> non-hyphenated form becomes the exclusively used form.  It does seem that
> re-enable → reenable is occurring, based on those search hits.

Hyphens do sometimes disappear, but not for re-e*, OED version
2 does not allow a single such instance.
> 
> Andi> Similar with upto.
> 
> I’ve a *much* harder time agreeing with «upto» in place of «up to».
> That should be treated as a typo in need of fixing.

Indeed .. upto is not a word.
> 
> -JimC

