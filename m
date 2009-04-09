Return-Path: <linux-kernel-owner+w=401wt.eu-S934670AbZDIPEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934670AbZDIPEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759707AbZDIPD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:03:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39065 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbZDIPD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:03:57 -0400
Message-ID: <49DE0E18.1080902@ti.com>
Date: Thu, 9 Apr 2009 10:02:48 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronics.de>
Subject: Re: [RFC] Dynamic Tick and Deferrable Timer Support
References: <CF7665F795A4BE438425FE728CEACFA302F2436B52@dlee01.ent.ti.com>	<20090114221624.76ee8aa4.akpm@linux-foundation.org>	<7B4574D56E4ADF438756313E9A172A872CB8232E@dlee01.ent.ti.com>	<7E82351C108FA840AB1866AC776AEC46471B9452@orsmsx505.amr.corp.intel.com>	<7B4574D56E4ADF438756313E9A172A872CB82749@dlee01.ent.ti.com>	<1233081369.28350.68.camel@jamoon.sc.intel.com>	<7B4574D56E4ADF438756313E9A172A87319DD3DC@dlee01.ent.ti.com> <20090408155220.05350574.akpm@linux-foundation.org>
In-Reply-To: <20090408155220.05350574.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> Let me know if you would like me to re-post. 
> 
> That would be best.

Thanks. I re-posted the patch under a more meaningful title [1]. I also 
asked Venki to ack this one too for consistency.

Cheers
Jon

[1] [PATCH] Allow deferrable timers for intervals tv2-tv5 to be deferred
http://marc.info/?l=linux-kernel&m=123928900703751&w=2



