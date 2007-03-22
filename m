Return-Path: <linux-kernel-owner+w=401wt.eu-S965705AbXCVFEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965705AbXCVFEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 01:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965714AbXCVFEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 01:04:33 -0400
Received: from mail09.syd.optusnet.com.au ([211.29.132.190]:43720 "EHLO
	mail09.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965705AbXCVFEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 01:04:33 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sched: rsdl improvements
Date: Thu, 22 Mar 2007 16:03:55 +1100
User-Agent: KMail/1.9.5
Cc: linux list <linux-kernel@vger.kernel.org>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200703220429.45311.kernel@kolivas.org> <20070321163658.535cbd7e.akpm@linux-foundation.org>
In-Reply-To: <20070321163658.535cbd7e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703221603.56072.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 March 2007 10:36, Andrew Morton wrote:
> On Thu, 22 Mar 2007 04:29:44 +1100
>
> Con Kolivas <kernel@kolivas.org> wrote:
> > Further improve the deterministic nature of the RSDL cpu scheduler and
> > make the rr_interval tunable.
>
> I might actually need to drop RSDL from next -mm, see if those sched oopses
> whcih several people have reported go away.

I did mention them in the changelog further down. While it may not be 
immediately apparent from the minimal emails I'm sending, I am trying hard to 
address every known regression in the time alloted. Without access to the 
hardware though I'm reliant on others testing it so I can't know for certain 
if I've fixed them.

-- 
-ck
