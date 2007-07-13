Return-Path: <linux-kernel-owner+w=401wt.eu-S937013AbXGMSXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937013AbXGMSXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935022AbXGMSXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:23:20 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:43547 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934678AbXGMSXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:23:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAGRgl0arR7MV/2dsb2JhbAA
X-IronPort-AV: i="4.16,537,1175497200"; 
   d="scan'208"; a="503063227:sNHT24633636"
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: Further 2.6.23 merge plans...
X-Message-Flag: Warning: May contain useful information
References: <adalkdl43w0.fsf@cisco.com> <adahco943ip.fsf@cisco.com>
	<20070713054711.GA21709@mellanox.co.il>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 13 Jul 2007 11:14:31 -0700
In-Reply-To: <20070713054711.GA21709@mellanox.co.il> (Michael S. Tsirkin's message of "Fri, 13 Jul 2007 08:47:11 +0300")
Message-ID: <adar6nc2mt4.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Jul 2007 18:14:31.0317 (UTC) FILETIME=[A8917C50:01C7C579]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Any plans to do something with multiple EQ support in mthca?

I haven't done any work on it or seen anything from anyone else, so I
expect this will have to wait for 2.6.24.
