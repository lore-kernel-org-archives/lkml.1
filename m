Return-Path: <linux-kernel-owner+w=401wt.eu-S1752677AbYDOEB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbYDOEB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 00:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYDOEB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 00:01:27 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:44451 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbYDOEBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 00:01:25 -0400
X-IronPort-AV: E=Sophos;i="4.25,658,1199692800"; 
   d="scan'208";a="21636734"
From: Roland Dreier <rdreier@cisco.com>
To: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
Cc: ewg@lists.openfabrics.org, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       rolandd@cisco.com, hnguyen@de.ibm.com, raisch@de.ibm.com,
       fenkes@de.ibm.com
Subject: Re: [PATCH] IB/ehca: extend query_device() and query_port() to support all values for ibv_devinfo
References: <200804071457.36248.ossrosch@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 14 Apr 2008 21:01:24 -0700
In-Reply-To: <200804071457.36248.ossrosch@linux.vnet.ibm.com> (Stefan
	Roscher's message of "Mon, 7 Apr 2008 13:57:33 +0100")
Message-ID: <adad4orpy0b.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Apr 2008 04:01:24.0460 (UTC) FILETIME=[5F3FB2C0:01C89EAD]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
