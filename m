Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbZLIWcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbZLIWcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 17:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbZLIWcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 17:32:47 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:27595 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758195AbZLIWcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 17:32:45 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.47,370,1257120000"; 
   d="scan'208";a="447298965"
From: Roland Dreier <rdreier@cisco.com>
To: Julia Lawall <julia@diku.dk>
Cc: "Tung\, Chien Tin" <chien.tin.tung@intel.com>,
       "Latif\, Faisal" <faisal.latif@intel.com>,
       Roland Dreier <rolandd@cisco.com>,
       "Hefty\, Sean" <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>,
       "linux-rdma\@vger.kernel.org" <linux-rdma@vger.kernel.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors\@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 3/5] drivers/infiniband: correct size computation
References: <Pine.LNX.4.64.0912061015540.20858@ask.diku.dk>
	<603F8A3875DCE940BA37B49D0A6EA0AE3CE36BF4@azsmsx501.amr.corp.intel.com>
	<Pine.LNX.4.64.0912071720520.15109@ask.diku.dk>
	<603F8A3875DCE940BA37B49D0A6EA0AE3CE36C9F@azsmsx501.amr.corp.intel.com>
	<Pine.LNX.4.64.0912072056160.1202@ask.diku.dk>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 09 Dec 2009 14:32:51 -0800
In-Reply-To: <Pine.LNX.4.64.0912072056160.1202@ask.diku.dk> (Julia Lawall's
	message of "Mon, 7 Dec 2009 20:57:06 +0100 (CET)")
Message-ID: <ada3a3jrd64.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Dec 2009 22:32:51.0746 (UTC) FILETIME=[8B0F4020:01CA791F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied, thanks everyone.
