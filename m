Return-Path: <linux-kernel-owner+w=401wt.eu-S932966AbXGPQdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbXGPQdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762529AbXGPQc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:32:58 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:54664 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761033AbXGPQc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:32:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAKs5m0arR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.16,542,1175497200"; 
   d="scan'208"; a="385936288:sNHT76551568"
To: Steve Wise <swise@opengridcomputing.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2.6.23] iw_cxgb3: remove the cm_id reference on listen failures.
X-Message-Flag: Warning: May contain useful information
References: <20070711180435.11665.71117.stgit@dell3.ogc.int>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 16 Jul 2007 09:32:52 -0700
Message-ID: <aday7hgxqa3.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Jul 2007 16:32:53.0064 (UTC) FILETIME=[F4F72C80:01C7C7C6]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
