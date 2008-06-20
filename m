Return-Path: <linux-kernel-owner+w=401wt.eu-S1759816AbYFTR06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816AbYFTR06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 13:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755890AbYFTR0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 13:26:40 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:58246 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759523AbYFTR0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 13:26:38 -0400
X-IronPort-AV: E=Sophos;i="4.27,680,1204531200"; 
   d="scan'208";a="33488484"
From: Roland Dreier <rdreier@cisco.com>
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: Dotan Barak <dotanba@gmail.com>, LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       OF-General <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, OF-EWG <ewg@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>
Subject: Re: [PATCH] IB/ehca: Reject recv WRs if QP is in RESET state
References: <200806061835.43802.fenkes@de.ibm.com>
	<48499C11.7030504@gmail.com> <200806091324.20869.fenkes@de.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 20 Jun 2008 10:26:34 -0700
In-Reply-To: <200806091324.20869.fenkes@de.ibm.com> (Joachim Fenkes's message
	of "Mon, 9 Jun 2008 13:24:20 +0200")
Message-ID: <adamylghvat.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Jun 2008 17:26:34.0379 (UTC) FILETIME=[C977D5B0:01C8D2FA]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
