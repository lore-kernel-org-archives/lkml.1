Return-Path: <linux-kernel-owner+w=401wt.eu-S1763753AbXILUWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763753AbXILUWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 16:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbXILUWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 16:22:08 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:12029 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbXILUWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 16:22:07 -0400
X-IronPort-AV: E=Sophos;i="4.20,246,1186383600"; 
   d="scan'208";a="398627348"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 02/12] IB/ehca: Add 1 is not longer needed because of firmware interface change
X-Message-Flag: Warning: May contain useful information
References: <200709111518.26276.fenkes@de.ibm.com>
	<200709111529.07935.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 12 Sep 2007 13:21:54 -0700
In-Reply-To: <200709111529.07935.fenkes@de.ibm.com> (Joachim Fenkes's message of "Tue, 11 Sep 2007 15:29:07 +0200")
Message-ID: <adaodg7ocrh.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Sep 2007 20:21:54.0649 (UTC) FILETIME=[8F8C2490:01C7F57A]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What happens if someone runs the new driver with older firmware?  Or
what if someone upgrades the firmware without updating the driver?

 - R.
