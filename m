Return-Path: <linux-kernel-owner+w=401wt.eu-S1765595AbXGPPEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765595AbXGPPEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 11:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764469AbXGPPDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 11:03:54 -0400
Received: from p02c11o142.mxlogic.net ([208.65.144.75]:51823 "EHLO
	p02c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762468AbXGPPDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 11:03:52 -0400
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jul 2007 11:03:51 EDT
Date: Mon, 16 Jul 2007 17:55:33 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Shirley Ma <xma@us.ibm.com>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       general@lists.openfabrics.org, general-bounces@lists.openfabrics.org,
       linux-kernel@vger.kernel.org, Roland Dreier <rdreier@cisco.com>
Subject: Re: [ofa-general] Re: Further 2.6.23 merge plans...
Message-ID: <20070716145533.GC4454@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <20070714175425.GA17597@mellanox.co.il> <OF72F6B9D1.F60C4EEF-ON8725731A.00506757-8825731A.0024BD1C@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF72F6B9D1.F60C4EEF-ON8725731A.00506757-8825731A.0024BD1C@us.ibm.com>
User-Agent: Mutt/1.5.11
X-OriginalArrivalTime: 16 Jul 2007 14:57:19.0049 (UTC) FILETIME=[9B39EB90:01C7C7B9]
X-Spam: [F=0.0100000000; S=0.010(2007062701); SS=0.500]
X-MAIL-FROM: <mst@dev.mellanox.co.il>
X-SOURCE-IP: [194.90.237.34]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Shirley Ma <xma@us.ibm.com>:
> Subject: Re: [ofa-general] Re: Further 2.6.23 merge plans...
> 
> Michael,
> 
> I would like to try this patch for one adapter/2 ports scalability performance
> for IPoIB. Is this patch appliable to OFED-1.2?

Most likely yes.

-- 
MST
