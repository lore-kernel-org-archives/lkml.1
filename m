Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbYJVWwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbYJVWwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbYJVWv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:51:56 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:40118 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbYJVWvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:51:55 -0400
X-IronPort-AV: E=Sophos;i="4.33,467,1220227200"; 
   d="scan'208";a="180705211"
From: Roland Dreier <rdreier@cisco.com>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, raisch@de.ibm.com,
       hnguyen@de.ibm.com, fenkes@de.ibm.com, alexschm@de.ibm.com,
       stefan.roscher@de.ibm.com
Subject: Re: [PATCH] IB/ehca: Fix problem with max number of QPs and CQs in systems with different adapters
References: <200810171349.12686.ossrosch@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 22 Oct 2008 15:51:53 -0700
In-Reply-To: <200810171349.12686.ossrosch@linux.vnet.ibm.com> (Stefan
	Roscher's message of "Fri, 17 Oct 2008 13:49:10 +0200")
Message-ID: <adawsg0utti.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Oct 2008 22:51:53.0758 (UTC) FILETIME=[C725B3E0:01C93498]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
