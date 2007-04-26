Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbXDZNiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbXDZNiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbXDZNiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:38:11 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:32940 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbXDZNiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:38:07 -0400
Message-ID: <4630AA9E.9030807@bull.net>
Date: Thu, 26 Apr 2007 15:35:26 +0200
From: Pierre Peiffer <pierre.peiffer@bull.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Ulrich Drepper <drepper@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org, Rusty Russel <rusty@rustcorp.com.au>
Subject: Re: [PATCH, take6] FUTEX : new PRIVATE futexes
References: <20060808070708.GA3931@localhost.localdomain>	<200608090826.28249.dada1@cosmosbay.com>	<200608090843.52893.dada1@cosmosbay.com>	<200703152010.35614.dada1@cosmosbay.com>	<a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>	<20070405194942.1414c030.dada1@cosmosbay.com>	<20070407104339.6674336b.dada1@cosmosbay.com>	<20070411111913.6115dac8.dada1@cosmosbay.com> <20070426145521.0f8b6b35.dada1@cosmosbay.com>
In-Reply-To: <20070426145521.0f8b6b35.dada1@cosmosbay.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 26/04/2007 15:40:48,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 26/04/2007 15:40:54,
	Serialize complete at 26/04/2007 15:40:54
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Hi Andrew
> 
> Not sure if you prefer to wait Pierre work on futex64, so just in case, I prepared this patch.
> 
> Update on this take6 :
> 
> - Rebased on linux-2.6.21-rc7-mm2 , since futex64 were droped from mm
> 
> 
> Pierre, I can resubmit another patch on top on your next patch, so please do as you prefer (ignoring or not this patch)

Thank you for taking care of this.
But I think your patch is more mature than the futex64 patch; So, it's ok for 
me, and it's probably simpler and better for "the community" (and for Andrew's 
work) to put this patch first, because futex64 still may need several reworks...

-- 
Pierre
