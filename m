Return-Path: <linux-kernel-owner+w=401wt.eu-S933373AbXHaU7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373AbXHaU7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 16:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760869AbXHaU7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 16:59:11 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:49581 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760664AbXHaU7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 16:59:08 -0400
X-IronPort-AV: i="4.20,194,1186383600"; 
   d="scan'208"; a="9284982:sNHT20136060"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 2/2] IB/ehca: SRQ fixes to enable IPoIB CM
X-Message-Flag: Warning: May contain useful information
References: <200708311601.42220.fenkes@de.ibm.com>
	<200708311603.38822.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 31 Aug 2007 13:59:03 -0700
In-Reply-To: <200708311603.38822.fenkes@de.ibm.com> (Joachim Fenkes's message of "Fri, 31 Aug 2007 16:03:37 +0200")
Message-ID: <adamyw7whd4.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 Aug 2007 20:59:03.0630 (UTC) FILETIME=[C32AA6E0:01C7EC11]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied 1 and 2.
