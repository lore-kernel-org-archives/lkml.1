Return-Path: <linux-kernel-owner+w=401wt.eu-S1761515AbXJREsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761515AbXJREsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 00:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbXJREsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 00:48:05 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:12892 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbXJREsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 00:48:03 -0400
X-IronPort-AV: E=Sophos;i="4.21,293,1188802800"; 
   d="scan'208";a="238989608"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>, Roland Dreier <rolandd@cisco.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 5/5] IB/ehca: Enable large page MRs by default
X-Message-Flag: Warning: May contain useful information
References: <200710161722.29144.fenkes@de.ibm.com>
	<200710161731.59688.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 17 Oct 2007 21:48:00 -0700
In-Reply-To: <200710161731.59688.fenkes@de.ibm.com> (Joachim Fenkes's message of "Tue, 16 Oct 2007 17:31:59 +0200")
Message-ID: <adair55f2pr.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Oct 2007 04:48:01.0032 (UTC) FILETIME=[0FC7B880:01C81142]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied 1-5
