Return-Path: <linux-kernel-owner+w=401wt.eu-S1946092AbXD3QaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946092AbXD3QaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946353AbXD3QaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:30:20 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:9424 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946092AbXD3QaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:30:18 -0400
X-IronPort-AV: i="4.14,471,1170662400"; 
   d="scan'208"; a="417089021:sNHT162092914"
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: What's in infiniband.git for 2.6.22
X-Message-Flag: Warning: May contain useful information
References: <adaps5rro8v.fsf@cisco.com> <20070427153016.GB1709@mellanox.co.il>
	<adaslalm9sd.fsf@cisco.com> <20070429075112.GA7869@mellanox.co.il>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 30 Apr 2007 09:30:16 -0700
In-Reply-To: <20070429075112.GA7869@mellanox.co.il> (Michael S. Tsirkin's message of "Sun, 29 Apr 2007 10:51:12 +0300")
Message-ID: <adaslahlt9j.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Apr 2007 16:30:16.0185 (UTC) FILETIME=[D5A69690:01C78B44]
Authentication-Results: sj-dkim-7; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim7002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > I think you want to queue the following obvios bugix up as well:
 > http://www.openfabrics.org/git/?p=~vlad/ofed_1_2/.git;a=blob;f=kernel_patches/fixes/ipoib_crash_on_error.patch;hb=HEAD

Yes, I'll get that one too.
