Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbXISRQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbXISRQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbXISRQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:16:33 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:9666 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbXISRQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:16:32 -0400
X-IronPort-AV: E=Sophos;i="4.20,274,1186383600"; 
   d="scan'208";a="400264591"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 2/3] IB/umem: Add hugetlb flag to struct ib_umem
X-Message-Flag: Warning: May contain useful information
References: <200709131814.13937.fenkes@de.ibm.com>
	<200709131815.29040.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 19 Sep 2007 10:16:07 -0700
In-Reply-To: <200709131815.29040.fenkes@de.ibm.com> (Joachim Fenkes's message of "Thu, 13 Sep 2007 18:15:28 +0200")
Message-ID: <adatzpqinjc.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 Sep 2007 17:16:07.0788 (UTC) FILETIME=[C46462C0:01C7FAE0]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This looks realy nice to me... a very clean patch.

I'll add this to 2.6.24 unless someone objects soon...
