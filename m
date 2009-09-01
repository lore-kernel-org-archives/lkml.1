Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbZIATzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbZIATzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 15:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZIATzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 15:55:14 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:26428 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbZIATzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 15:55:13 -0400
X-IronPort-AV: E=Sophos;i="4.44,313,1249257600"; 
   d="scan'208";a="92474079"
From: Roland Dreier <rdreier@cisco.com>
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       OF-General <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, OF-EWG <ewg@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Alexander Schmidt <alexschm@de.ibm.com>
Subject: Re: [PATCH] IB/ehca: Fix CQE flags reporting
References: <200806061835.43802.fenkes@de.ibm.com>
	<48499C11.7030504@gmail.com> <200909011355.34319.fenkes@de.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 01 Sep 2009 12:55:15 -0700
In-Reply-To: <200909011355.34319.fenkes@de.ibm.com> (Joachim Fenkes's message
	of "Tue, 1 Sep 2009 13:55:33 +0200")
Message-ID: <ada7hwio2xo.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Sep 2009 19:55:15.0575 (UTC) FILETIME=[1FD8D070:01CA2B3E]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied, thanks
