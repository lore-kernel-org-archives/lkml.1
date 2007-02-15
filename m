Return-Path: <linux-kernel-owner+w=401wt.eu-S1030324AbXBORsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030324AbXBORsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 12:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030367AbXBORsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 12:48:25 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:29317 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030324AbXBORsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 12:48:24 -0500
X-IronPort-AV: i="4.14,176,1170662400"; 
   d="scan'208"; a="464806706:sNHT43330760"
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, hch@infradead.org, bos@pathscale.com,
       raisch@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [PATCH 2.6.21-rc1 5/5] ehca: query_port() returns LINK_UP instead UNKNOWN
X-Message-Flag: Warning: May contain useful information
References: <200702151710.06432.hnguyen@linux.vnet.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 15 Feb 2007 09:48:14 -0800
In-Reply-To: <200702151710.06432.hnguyen@linux.vnet.ibm.com> (Hoang-Nam Nguyen's message of "Thu, 15 Feb 2007 17:10:06 +0100")
Message-ID: <ada4ppntiqp.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Feb 2007 17:48:16.0928 (UTC) FILETIME=[7905CA00:01C75129]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, queued 1, 2, 3 and 5 for 2.6.21.
