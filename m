Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbYLUV2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbYLUV2S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 16:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbYLUV2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 16:28:01 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:46968 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbYLUV2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 16:28:00 -0500
X-IronPort-AV: E=Sophos;i="4.36,260,1228089600"; 
   d="scan'208";a="217351044"
From: Roland Dreier <rdreier@cisco.com>
To: Julia Lawall <julia@diku.dk>
Cc: rolandd@cisco.com, sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, hnguyen@de.ibm.com, raisch@de.ibm.com
Subject: Re: [PATCH 3/13] drivers/infiniband/hw/ehca: Remove redundant test
References: <Pine.LNX.4.64.0812211636550.9555@pc-004.diku.dk>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 21 Dec 2008 13:27:57 -0800
In-Reply-To: <Pine.LNX.4.64.0812211636550.9555@pc-004.diku.dk> (Julia Lawall's
	message of "Sun, 21 Dec 2008 16:37:17 +0100 (CET)")
Message-ID: <adaiqpdxlpe.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Dec 2008 21:27:58.0600 (UTC) FILETIME=[FEBE9080:01C963B2]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied for 2.6.29 (ehca guys added to cc list just to make sure
this is OK).

 - R.
