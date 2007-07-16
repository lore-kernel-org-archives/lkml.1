Return-Path: <linux-kernel-owner+w=401wt.eu-S1763316AbXGPQnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763316AbXGPQnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760358AbXGPQm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:42:58 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:42550 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760021AbXGPQm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:42:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAMc7m0arR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.16,542,1175497200"; 
   d="scan'208"; a="182914375:sNHT58792086"
To: tziporet@dev.mellanox.co.il
Cc: linux-kernel@vger.kernel.org, general@lists.openfabrics.org
Subject: Re: [ofa-general] Further 2.6.23 merge plans...
X-Message-Flag: Warning: May contain useful information
References: <adalkdl43w0.fsf@cisco.com> <adahco943ip.fsf@cisco.com>
	<469A1293.6020902@mellanox.co.il>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 16 Jul 2007 09:42:53 -0700
Message-ID: <adahco4xpte.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Jul 2007 16:42:53.0288 (UTC) FILETIME=[5ABA1680:01C7C7C8]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Till when can we insert mlx4 with FMRs?

2.6.22 came out on July 8, so I would expect 2.6.23-rc1 (the end of
the merge window) to be July 22.
