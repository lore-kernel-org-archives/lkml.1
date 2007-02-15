Return-Path: <linux-kernel-owner+w=401wt.eu-S1750729AbXBOVtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750729AbXBOVtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbXBOVtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:49:04 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:46898 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbXBOVtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:49:02 -0500
X-IronPort-AV: i="4.14,178,1170662400"; 
   d="scan'208"; a="113197393:sNHT38274876"
To: Steve Wise <swise@opengridcomputing.com>
Cc: openib-general <openib-general@openib.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] 2.6.21 iw_cxgb3 Fail posts synchronously when in TERMINATE state.
X-Message-Flag: Warning: May contain useful information
References: <1171550942.13282.5.camel@stevo-desktop>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 15 Feb 2007 13:48:57 -0800
In-Reply-To: <1171550942.13282.5.camel@stevo-desktop> (Steve Wise's message of "Thu, 15 Feb 2007 08:49:02 -0600")
Message-ID: <adasld7ozw6.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Feb 2007 21:48:55.0870 (UTC) FILETIME=[174D7DE0:01C7514B]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
