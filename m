Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbXKGTqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbXKGTqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 14:46:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbXKGTpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 14:45:54 -0500
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:57156 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbXKGTpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 14:45:53 -0500
X-IronPort-AV: E=Sophos;i="4.21,386,1188802800"; 
   d="scan'208";a="30937654"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 2/2] IB/ehca: Fix static rate calculation
X-Message-Flag: Warning: May contain useful information
References: <200711021432.50203.fenkes@de.ibm.com>
	<200711021441.50158.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 07 Nov 2007 11:45:49 -0800
In-Reply-To: <200711021441.50158.fenkes@de.ibm.com> (Joachim Fenkes's message of "Fri, 2 Nov 2007 15:41:49 +0200")
Message-ID: <adar6j17sb6.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Nov 2007 19:45:49.0974 (UTC) FILETIME=[CC6EF360:01C82176]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied both patches.
