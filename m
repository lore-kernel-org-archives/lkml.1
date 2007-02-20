Return-Path: <linux-kernel-owner+w=401wt.eu-S965620AbXBTAMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965620AbXBTAMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965617AbXBTALy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:11:54 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:7671 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965613AbXBTALf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:11:35 -0500
X-IronPort-AV: i="4.14,192,1170662400"; 
   d="scan'208"; a="465594551:sNHT43622712"
To: Adrian Bunk <bunk@stusta.de>
Cc: "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Roland Dreier <rolandd@cisco.com>, mshefty@ichips.intel.com,
       halr@voltaire.com, openib-general@openib.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] infiniband/hw/mthca/mthca_mr.c: make 2 functions static
X-Message-Flag: Warning: May contain useful information
References: <20070220000213.GA13958@stusta.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 19 Feb 2007 16:11:27 -0800
In-Reply-To: <20070220000213.GA13958@stusta.de> (Adrian Bunk's message of "Tue, 20 Feb 2007 01:02:13 +0100")
Message-ID: <adaps85y9g0.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Feb 2007 00:11:28.0184 (UTC) FILETIME=[AA880B80:01C75483]
Authentication-Results: sj-dkim-7; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim7002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Queued for my next merge, thanks.
