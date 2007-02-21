Return-Path: <linux-kernel-owner+w=401wt.eu-S932785AbXBUHTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785AbXBUHTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 02:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932798AbXBUHTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 02:19:32 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:21679 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932785AbXBUHTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 02:19:31 -0500
X-IronPort-AV: i="4.14,200,1170662400"; 
   d="scan'208"; a="41170965:sNHT57983337"
To: Steve Wise <swise@opengridcomputing.com>
Cc: Adrian Bunk <bunk@stusta.de>, Roland Dreier <rolandd@cisco.com>,
       linux-kernel@vger.kernel.org, mshefty@ichips.intel.com,
       halr@voltaire.com, openib-general@openib.org
Subject: Re: [2.6 patch] drivers/infiniband/hw/cxgb3/: possible cleanups
X-Message-Flag: Warning: May contain useful information
References: <20070220000211.GZ13958@stusta.de>
	<1171982587.2101.0.camel@stevo-desktop>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 20 Feb 2007 23:19:28 -0800
In-Reply-To: <1171982587.2101.0.camel@stevo-desktop> (Steve Wise's message of "Tue, 20 Feb 2007 08:43:06 -0600")
Message-ID: <ada3b50dlkv.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Feb 2007 07:19:28.0385 (UTC) FILETIME=[9F897F10:01C75588]
Authentication-Results: sj-dkim-6; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim6002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > You could just remove the code instead of #if 0...

Steve, can you decide what the right thing to do with these changes is
and send me the result (or just tell me to apply Adrian's patch
as-is)?

Thanks,
  Roland
