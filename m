Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbYKDVhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbYKDVhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 16:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbYKDVhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 16:37:12 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:15323 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbYKDVhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 16:37:10 -0500
X-IronPort-AV: E=Sophos;i="4.33,545,1220227200"; 
   d="scan'208";a="101640082"
From: Roland Dreier <rdreier@cisco.com>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>, LKML <linux-kernel@vger.kernel.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>, raisch@de.ibm.com,
       hnguyen@de.ibm.com, fenkes@de.ibm.com, stefan.roscher@de.ibm.com,
       alexschm@de.ibm.com
Subject: Re: [PATCH] IB/ehca: remove reference to the QP in case of port activation failure
References: <200811041554.45560.ossrosch@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 04 Nov 2008 13:37:08 -0800
In-Reply-To: <200811041554.45560.ossrosch@linux.vnet.ibm.com> (Stefan
	Roscher's message of "Tue, 4 Nov 2008 15:54:43 +0100")
Message-ID: <adawsfjrx4r.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Nov 2008 21:37:09.0180 (UTC) FILETIME=[7D8027C0:01C93EC5]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
