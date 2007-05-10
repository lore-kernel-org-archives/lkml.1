Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbXEJDDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbXEJDDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 23:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbXEJDDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 23:03:08 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:31613 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbXEJDDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 23:03:06 -0400
X-IronPort-AV: i="4.14,514,1170662400"; 
   d="scan'208"; a="146877219:sNHT39339486"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       "Christoph Raisch" <raisch@de.ibm.com>,
       "Stefan Roscher" <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 1/6] IB/ehca: Serialize hypervisor calls in ehca_register_mr()
X-Message-Flag: Warning: May contain useful information
References: <200705091347.57470.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 09 May 2007 20:03:03 -0700
In-Reply-To: <200705091347.57470.fenkes@de.ibm.com> (Joachim Fenkes's message of "Wed, 9 May 2007 13:47:56 +0200")
Message-ID: <adak5vh2xeg.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 May 2007 03:03:03.0576 (UTC) FILETIME=[B9B27180:01C792AF]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, it all looks fine... I'll apply when I'm back from my trip on Monday.
