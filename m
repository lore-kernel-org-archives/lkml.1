Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbYADFG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbYADFG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 00:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYADFGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 00:06:49 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:19414 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbYADFGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 00:06:48 -0500
X-IronPort-AV: E=Sophos;i="4.24,243,1196668800"; 
   d="scan'208";a="30206330"
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org, fenkes@de.ibm.com,
       Christoph Raisch <RAISCH@de.ibm.com>, stefan.roscher@de.ibm.com
Subject: Re: [ofa-general] [PATCH] IB/ehca: Forward event client-reregister-required to registered clients
X-Message-Flag: Warning: May contain useful information
References: <200712201506.34253.hnguyen@linux.vnet.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 03 Jan 2008 21:06:41 -0800
In-Reply-To: <200712201506.34253.hnguyen@linux.vnet.ibm.com> (Hoang-Nam Nguyen's message of "Thu, 20 Dec 2007 15:06:33 +0100")
Message-ID: <ada4pdurxge.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Jan 2008 05:06:41.0875 (UTC) FILETIME=[98134A30:01C84E8F]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
