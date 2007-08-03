Return-Path: <linux-kernel-owner+w=401wt.eu-S1760399AbXHCUal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760399AbXHCUal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 16:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760950AbXHCUac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 16:30:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:37468 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760326AbXHCUaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 16:30:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,218,1183359600"; 
   d="scan'208";a="274375311"
Message-ID: <46B39063.6070301@intel.com>
Date: Fri, 03 Aug 2007 13:30:27 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Andrew Gallatin <gallatin@myri.com>
CC: netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com, stefan.roscher@de.ibm.com, jeff@garzik.org,
       davem@davemloft.net
Subject: Re: [PATCH] lro: myri10ge example how to use LRO
References: <46B363A8.4010407@myri.com>
In-Reply-To: <46B363A8.4010407@myri.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Aug 2007 20:30:29.0501 (UTC) FILETIME=[21E652D0:01C7D60D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Gallatin wrote:
> To follow up on Jan-Bernd Themann's LRO patch earlier today,
> this patch shows how the generic LRO interface can be used for
> page based drivers.
> 
> Again, many thanks to Jan-Bernd Themann for leading this effort.
> 
> Drew
> 
> Singed off by: Andrew Gallatin <gallatin@myri.com>
> 


please take a look at my lro patch for ethtool and see if it works for you, 
instead of adding another generic module parameter that doesn't need to be there.

Thanks.

Auke
