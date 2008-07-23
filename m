Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbYGWMYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbYGWMYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 08:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbYGWMYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 08:24:01 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:43715 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYGWMYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 08:24:01 -0400
Message-ID: <488722F6.1000400@us.ibm.com>
Date: Wed, 23 Jul 2008 07:24:22 -0500
From: Maynard Johnson <maynardj@us.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 0/24] oprofile: Add IBS support for AMD CPUs
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter wrote:
> Patches #1-3 are not directly related to IBS.
> Patch #4 adds generic support of model specific initialization.
>   
And patches 5-9 are for . . .

It seems that you have 5 independent patch sets here.  I don't see any
advantage in posting them together in one large group -- maybe more of a
disadvantage, since some are pretty non-controversial and should get
accepted fairly easily, while others will probably result in extended
discussion.  You might consider reposting these 5 patch sets
individually.  But I'm not so familiar with kernel patch
review/acceptance process, so maybe this is fine as it is if subsets of
the 24 patches are accepted incrementally.

-Maynard
> Patches #10, #11 add the core implementation of IBS.
> Patches #12-24 contain code improvements and small fixes.
>
>
>
>
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> oprofile-list mailing list
> oprofile-list@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/oprofile-list
>   


