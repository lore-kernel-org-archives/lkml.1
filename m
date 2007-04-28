Return-Path: <linux-kernel-owner+w=401wt.eu-S1030972AbXD1D4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030972AbXD1D4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 23:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031003AbXD1D4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 23:56:39 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:28037 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030972AbXD1D4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 23:56:37 -0400
X-IronPort-AV: i="4.14,463,1170662400"; 
   d="scan'208"; a="141717970:sNHT41593590"
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: What's in infiniband.git for 2.6.22
X-Message-Flag: Warning: May contain useful information
References: <adaps5rro8v.fsf@cisco.com> <20070427153016.GB1709@mellanox.co.il>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 27 Apr 2007 20:56:34 -0700
In-Reply-To: <20070427153016.GB1709@mellanox.co.il> (Michael S. Tsirkin's message of "Fri, 27 Apr 2007 18:30:16 +0300")
Message-ID: <adaslalm9sd.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Apr 2007 03:56:35.0009 (UTC) FILETIME=[36E73B10:01C78949]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > What about the mthca patch to use separate HW queues for kernel RC/UD/userspace RC?

right, I'll queue that up too.
BTW is there something analogous we could do for mlx4, or is FW not
quite ready?

 - R.
