Return-Path: <linux-kernel-owner+w=401wt.eu-S932673AbXIQWMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbXIQWMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 18:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbXIQWM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 18:12:29 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:59058 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbXIQWM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 18:12:28 -0400
X-IronPort-AV: E=Sophos;i="4.20,266,1186383600"; 
   d="scan'208";a="10240350"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 1/3] IB/ehca: Fix large page HW cap defines
X-Message-Flag: Warning: May contain useful information
References: <200709131814.13937.fenkes@de.ibm.com>
	<200709131814.59307.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 17 Sep 2007 15:12:18 -0700
In-Reply-To: <200709131814.59307.fenkes@de.ibm.com> (Joachim Fenkes's message of "Thu, 13 Sep 2007 18:14:58 +0200")
Message-ID: <adafy1dlz5p.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Sep 2007 22:12:18.0824 (UTC) FILETIME=[CFEDC880:01C7F977]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

obviously OK...applied.
