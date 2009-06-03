Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbZFCU0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbZFCU0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 16:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbZFCU0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 16:26:00 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:11069 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbZFCU0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 16:26:00 -0400
X-IronPort-AV: E=Sophos;i="4.41,299,1241395200"; 
   d="scan'208";a="194498183"
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
Subject: Re: [PATCH] IB/ehca: Remove superfluous bitmasks from QP control block
References: <200806061835.43802.fenkes@de.ibm.com>
	<48499C11.7030504@gmail.com> <200906031628.19556.fenkes@de.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 03 Jun 2009 13:26:01 -0700
In-Reply-To: <200906031628.19556.fenkes@de.ibm.com> (Joachim Fenkes's message
	of "Wed, 3 Jun 2009 16:28:17 +0200")
Message-ID: <adaoct59i92.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 Jun 2009 20:26:01.0487 (UTC) FILETIME=[82EB21F0:01C9E489]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

looks fine, applied for 2.6.31
