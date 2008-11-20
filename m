Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbYKTPRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbYKTPRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717AbYKTPRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:17:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:5837 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbYKTPRl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:17:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,639,1220252400"; 
   d="scan'208";a="641569711"
From: "Zou, Yi" <yi.zou@intel.com>
To: David Miller <davem@davemloft.net>
CC: "jeff@garzik.org" <jeff@garzik.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 20 Nov 2008 00:01:05 -0800
Subject: RE: [PATCH 3/3] net: define feature flags for FCoE offloads
Thread-Topic: [PATCH 3/3] net: define feature flags for FCoE offloads
Thread-Index: AclKrWqkrsWTvKRETRyBYNkVHGdW/gAOBx0g
Message-ID: <1DB50624F8348F48840F2E2CF6040A9D2F384148@orsmsx508.amr.corp.intel.com>
References: <20081117183049.15776.84674.stgit@zychongqing.jf.intel.com>
	<20081119.154710.135220757.davem@davemloft.net>
	<1DB50624F8348F48840F2E2CF6040A9D2F383FB5@orsmsx508.amr.corp.intel.com>
 <20081119.171426.197284550.davem@davemloft.net>
In-Reply-To: <20081119.171426.197284550.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: David Miller [mailto:davem@davemloft.net]
>Sent: Wednesday, November 19, 2008 5:14 PM
>
>From: "Zou, Yi" <yi.zou@intel.com>
>Date: Wed, 19 Nov 2008 16:02:03 -0800
>
>> Thanks for reviewing the patch. I am hoping to make use of the
>> existing gso logic as much as possible for fcoe segmentation as
>> well, to hookup fcoe segmentation using ptype->gso_segment().
>
>There is no way for anyone to evaluate this usage and determine
>whether it makes sense or not until you post those patches.
Sure, allow me some time to clean up and repost patches following
this to RFC for what I think can be changed to make the existing
gso logic also work for fcoe.

Thanks for the comments.

-yi
