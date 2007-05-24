Return-Path: <linux-kernel-owner+w=401wt.eu-S1751272AbXEXSF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbXEXSF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 14:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbXEXSFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 14:05:19 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:33168 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbXEXSFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 14:05:18 -0400
X-IronPort-AV: i="4.14,574,1170662400"; 
   d="scan'208"; a="153995476:sNHT39781134"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Christoph Raisch" <raisch@de.ibm.com>,
       "Stefan Roscher" <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH] IB/ehca: fix wrong number of send WRs returned
X-Message-Flag: Warning: May contain useful information
References: <200705241651.09411.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 24 May 2007 11:05:10 -0700
In-Reply-To: <200705241651.09411.fenkes@de.ibm.com> (Joachim Fenkes's message of "Thu, 24 May 2007 16:51:08 +0200")
Message-ID: <ada8xbe6qsp.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 May 2007 18:05:10.0593 (UTC) FILETIME=[11B24B10:01C79E2E]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
