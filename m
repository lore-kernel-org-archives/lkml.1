Return-Path: <linux-kernel-owner+w=401wt.eu-S1759402AbYHVHDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbYHVHDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 03:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbYHVHDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 03:03:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59520 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbYHVHDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 03:03:12 -0400
Date: Fri, 22 Aug 2008 09:02:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Diggs <kevdig@hypersurf.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org,
       david@fromorbit.com, arnd@arndb.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: {NOT a PATCH} Corrections please ...
Message-ID: <20080822070249.GW14110@elte.hu>
References: <48AB73A3.9010404@hypersurf.com> <20080820095908.GC28492@elte.hu> <48ABF880.5010605@s5r6.in-berlin.de> <48AC7790.8010207@hypersurf.com> <20080821103000.GA19452@elte.hu> <48ADC65F.6000705@hypersurf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48ADC65F.6000705@hypersurf.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kevin Diggs <kevdig@hypersurf.com> wrote:

> Ingo Molnar wrote:
>> * Kevin Diggs <kevdig@hypersurf.com> wrote:
>>
>>
>>> Here is the latest (maybe line wrap is set to 99 so it won't be 
>>> goofed anymore?):
>>
>>
>> the patch wont apply as it has whitespace corruption (double spaces).  
>> Please check Documentation/email-clients.txt.
>>
>> 	Ingo
>>
>>
> The double spacing between the diffs? That will prevent it from 
> applying?

No. It's a per line corruption. Instead of:

"+<space>code"

your mail had:

"+<space><space>code"

i usually fix that up for small patch but this wasnt a smaller patch :)

> Who should this patch be sent to when it is ready? Also, I think I 
> remember reading in submitting patches that patches should be cced to 
> the general linux-kernel list. This correct?

me would be fine, it's scheduler code. I can take MIME attachments too 
if that's easier for you.

	Ingo
