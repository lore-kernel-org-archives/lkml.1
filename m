Return-Path: <linux-kernel-owner+w=401wt.eu-S965463AbXH0WAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965463AbXH0WAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965507AbXH0V6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:58:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:19963 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965494AbXH0V62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:58:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,313,1183359600"; 
   d="scan'208";a="289019649"
Message-ID: <46D348ED.9020003@intel.com>
Date: Mon, 27 Aug 2007 14:58:05 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, jgarzik@pobox.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, saw@saw.sw.com.sg
Subject: Re: [2.6.24 patch] the planned eepro100 removal
References: <20070827212825.GY4121@stusta.de>
In-Reply-To: <20070827212825.GY4121@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Aug 2007 21:58:26.0914 (UTC) FILETIME=[6565A420:01C7E8F5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch contains the planned removal of the eepro100 driver.
> 
> Signed-off-by: Adrian Bunk 

you lost your e-mail address? :)

> ---
> 
> This patch has been sent on:
> - 14 Aug 2007
> - 29 Jul 2007

currently we won't have e100 fixed up for ARM in 2.6.23, so removing this for 
2.6.24 sounds a bit premature. Maybe 2.6.25. Can you reschedule/postpone this?

Auke
