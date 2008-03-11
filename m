Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbYCKE2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbYCKE2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYCKE2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:28:00 -0400
Received: from rtp-iport-2.cisco.com ([64.102.122.149]:28684 "EHLO
	rtp-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbYCKE17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:27:59 -0400
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Mar 2008 00:27:59 EDT
X-IronPort-AV: E=Sophos;i="4.25,478,1199682000"; 
   d="scan'208";a="1264091"
To: Erez Zilber <erezz@voltaire.com>
Cc: Arne Redlich <arne.redlich@xiranet.com>, Roland Dreier <rolandd@cisco.com>,
       ofa-general <general@lists.openfabrics.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] IB/iSER: handle iser_device allocation error gracefully
X-Message-Flag: Warning: May contain useful information
References: <87zltgw0ut.fsf@confield.dd.xiranet.com>
	<47CD3C8A.20405@voltaire.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 10 Mar 2008 21:18:30 -0700
In-Reply-To: <47CD3C8A.20405@voltaire.com> (Erez Zilber's message of "Tue, 04 Mar 2008 14:11:54 +0200")
Message-ID: <adahcfdnbah.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Mar 2008 04:18:31.0678 (UTC) FILETIME=[F70F79E0:01C8832E]
Authentication-Results: rtp-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/rtpdkim1001 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks applied
