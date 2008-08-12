Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbYHLSf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbYHLSf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 14:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYHLSfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 14:35:51 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:51272 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbYHLSfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 14:35:50 -0400
X-IronPort-AV: E=Sophos;i="4.32,197,1217808000"; 
   d="scan'208";a="94451174"
From: Roland Dreier <rdreier@cisco.com>
To: Alexander Schmidt <alexs@linux.vnet.ibm.com>
Cc: Roland Dreier <rolandd@cisco.com>, "of-ewg" <ewg@lists.openfabrics.org>,
       "of-general" <general@lists.openfabrics.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "linuxppc-dev" <linuxppc-dev@ozlabs.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>
Subject: Re: [PATCH 5/5 try2] ib/ehca: discard double CQE for one WR
References: <200808121546.31057.alexs@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 12 Aug 2008 11:35:48 -0700
In-Reply-To: <200808121546.31057.alexs@linux.vnet.ibm.com> (Alexander
	Schmidt's message of "Tue, 12 Aug 2008 15:46:30 +0200")
Message-ID: <adasktaw06z.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Aug 2008 18:35:49.0189 (UTC) FILETIME=[3DD24750:01C8FCAA]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied all 5.
