Return-Path: <linux-kernel-owner+w=401wt.eu-S1759105AbZLOIdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105AbZLOIdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 03:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759038AbZLOIdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 03:33:36 -0500
Received: from mail.mellanox.co.il ([194.90.237.43]:38575 "EHLO mellanox.co.il"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752565AbZLOIdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 03:33:35 -0500
Date: Tue, 15 Dec 2009 10:34:58 +0200
From: Eli Cohen <eli@dev.mellanox.co.il>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: InfiniBand/RDMA merge plans for 2.6.33
Message-ID: <20091215083458.GC10744@mtls03>
References: <adaocm1csgb.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaocm1csgb.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 15 Dec 2009 08:33:25.0330 (UTC) FILETIME=[44D09320:01CA7D61]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17070.004
X-TM-AS-Result: No--4.014600-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 10:37:40AM -0800, Roland Dreier wrote:
> 
> Here are a few topics that are not ready in time for the 2.6.33 window
> and will need to wait for 2.6.34 at least:
> 
> 
>  - IBoE.  In principle I think this is starting to get there.  Still
>    want to see better ABI compatibility at least, and also make sure
>    the interface chosen works for both rdmacm and non-rdmacm
>    applications.
> 

Based on this, I am going to send a new patch set, a few days after
2.6.33-rc1 is out.
