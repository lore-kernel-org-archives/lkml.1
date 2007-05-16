Return-Path: <linux-kernel-owner+w=401wt.eu-S1762883AbXEPSDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762883AbXEPSDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756489AbXEPSDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:03:32 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:39699
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbXEPSDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:03:32 -0400
Date: Wed, 16 May 2007 10:58:37 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Bill Davidsen <davidsen@tmr.com>
cc: Jeff Zheng <Jeff.Zheng@endace.com>, Neil Brown <neilb@suse.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Software raid0 will crash the file-system, when each disk is
 5TB
In-Reply-To: <464B3F23.50105@tmr.com>
Message-ID: <Pine.LNX.4.64.0705161058080.1280@asgard.lang.hm>
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com><6bffcb0e0705151629j78920ca2r9337dccdfc1bb6a9@mail.gmail.com>
 <17994.19043.771733.453896@notabene.brown> <659F626D666070439A4A5965CD6EBF406B31C5@gazelle.ad.endace.com>
 <464B3F23.50105@tmr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007, Bill Davidsen wrote:

> Jeff Zheng wrote:
>>  Here is the information of the created raid0. Hope it is enough.
>>
>> 
> If I read this correctly, the problem is with JFS rather than RAID?

he had the same problem with xfs.

David Lang

