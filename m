Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbYCKEdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbYCKEdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYCKEdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:33:03 -0400
Received: from ams-iport-1.cisco.com ([144.254.224.140]:5089 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYCKEdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:33:02 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Mar 2008 00:33:00 EDT
X-IronPort-AV: E=Sophos;i="4.25,478,1199660400"; 
   d="scan'208";a="3067689"
To: Steve Wise <swise@opengridcomputing.com>
Cc: sean.hefty@intel.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [PATCH 2.6.25] RDMA/IWCM: don't access the cm_id after dereferencing it.
X-Message-Flag: Warning: May contain useful information
References: <20080304224451.8548.33855.stgit@dell3.ogc.int>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 10 Mar 2008 21:23:16 -0700
In-Reply-To: <20080304224451.8548.33855.stgit@dell3.ogc.int> (Steve Wise's message of "Tue, 04 Mar 2008 16:44:52 -0600")
Message-ID: <adad4q1nb2j.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Mar 2008 04:23:17.0394 (UTC) FILETIME=[A15C4720:01C8832F]
Authentication-Results: ams-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/amsdkim1002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
