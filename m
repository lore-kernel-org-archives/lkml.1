Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbYHKV6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbYHKV6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbYHKV6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:58:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:29990 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbYHKV6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:58:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,191,1217833200"; 
   d="scan'208";a="369797362"
Message-ID: <48A0B571.7010903@intel.com>
Date: Mon, 11 Aug 2008 14:56:01 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080626)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: cl@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Rick Jones <rick.jones2@hp.com>
Subject: Re: tbench regression on each kernel release from 2.6.22 -> 2.6.28
References: <48A086B6.2000901@linux-foundation.org>	<20080811.141501.01468546.davem@davemloft.net>	<48A0B037.501@linux-foundation.org> <20080811.145047.105665450.davem@davemloft.net>
In-Reply-To: <20080811.145047.105665450.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Aug 2008 21:58:17.0252 (UTC) FILETIME=[5C37D640:01C8FBFD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Christoph Lameter <cl@linux-foundation.org>
> Date: Mon, 11 Aug 2008 16:33:43 -0500
> 
>> Maybe what we are seeing is general bloat in kernel execution paths
>> due to the growth in complexity?
> 
> It could be, and any kind of analysis into this would be great.

perhaps Rick Jones who maintains netperf could enlighten us on some historic
numbers? he usually seems to be happy to prop up new netperf numbers :)


Auke
