Return-Path: <linux-kernel-owner+w=401wt.eu-S1765246AbXINQF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765246AbXINQF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 12:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbXINQFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 12:05:17 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:4743 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbXINQFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 12:05:14 -0400
X-IronPort-AV: E=Sophos;i="4.20,256,1186383600"; 
   d="scan'208";a="218236879"
To: Joachim Fenkes <FENKES@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 02/12] IB/ehca: Add 1 is not longer needed because of firmware interface change
X-Message-Flag: Warning: May contain useful information
References: <OF628247C3.FB0AFE13-ONC1257355.005E8356-C1257356.004BCE85@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 14 Sep 2007 09:05:05 -0700
In-Reply-To: <OF628247C3.FB0AFE13-ONC1257355.005E8356-C1257356.004BCE85@de.ibm.com> (Joachim Fenkes's message of "Fri, 14 Sep 2007 15:48:00 +0200")
Message-ID: <ada8x79kzbi.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Sep 2007 16:05:05.0374 (UTC) FILETIME=[03BADFE0:01C7F6E9]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > If the rest of this patchset is okay with you, could you apply it and 
 > leave out this one patch? The patchset will apply cleanly without it.

Yes, no problem, I'll drop this patch for now.

 - R.
