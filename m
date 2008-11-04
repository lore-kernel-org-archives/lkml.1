Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYKDUJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYKDUJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 15:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYKDUJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 15:09:32 -0500
Received: from mga07.intel.com ([143.182.124.22]:16462 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752570AbYKDUJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 15:09:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,544,1220252400"; 
   d="scan'208";a="70892307"
Message-ID: <4910AC08.50306@linux.intel.com>
Date: Tue, 04 Nov 2008 21:09:44 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Eric Dumazet <dada1@cosmosbay.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-2.6.28-rc2 regression : oprofile doesnt work anymore ?
References: <4909F690.9090208@cosmosbay.com> <84144f020810310721x1d1eccbeica5d10608d7b2e57@mail.gmail.com> <20081104181855.GK9785@erda.amd.com>
In-Reply-To: <20081104181855.GK9785@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter wrote:
> Andi,
> 
> your patchset breaks oprofile on Intel Core 2 cpus. I could bisect the
> bug for c493756..5951290. Please take a look at this and send me a fix.

I'll take a look but it'll be some time because my test setup is still
not fully functional after moving.

-Andi
