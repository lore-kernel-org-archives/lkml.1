Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbZBPGtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbZBPGtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 01:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZBPGs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 01:48:59 -0500
Received: from mga14.intel.com ([143.182.124.37]:64484 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbZBPGs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 01:48:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,214,1233561600"; 
   d="scan'208";a="111041112"
Date: Sun, 15 Feb 2009 22:48:51 -0800 (Pacific Standard Time)
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: Hannes Eder <hannes@hanneseder.net>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 24/43] drivers/net/ixgbe: fix sparse warning: Should it
 be	static?
In-Reply-To: <20090214213822.24377.64757.stgit@vmbox.hanneseder.net>
Message-ID: <Pine.WNT.4.64.0902152248180.31128@ppwaskie-MOBL2.amr.corp.intel.com>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
 <20090214213822.24377.64757.stgit@vmbox.hanneseder.net>
ReplyTo: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
X-X-Sender: amrppwaskie@imapmail.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Impact: Make symbol static.
> 
> Fix this sparse warning:
>   drivers/net/ixgbe/ixgbe_82598.c:59:5: warning: symbol 'ixgbe_get_pcie_msix_count_82598' was not declared. Should it be static?
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Acked-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
