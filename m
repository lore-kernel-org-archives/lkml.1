Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbYHGPXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbYHGPXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 11:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYHGPXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 11:23:12 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:62945 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbYHGPXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 11:23:11 -0400
X-IronPort-AV: E=Sophos;i="4.31,320,1215388800"; 
   d="scan'208";a="62782885"
From: Roland Dreier <rdreier@cisco.com>
To: Julien Brunel <brunel@diku.dk>
Cc: rolandd@cisco.com, sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/infiniband/core: Use an IS_ERR test rather than a NULL test
References: <200808071715.54004.brunel@diku.dk>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 07 Aug 2008 08:23:09 -0700
In-Reply-To: <200808071715.54004.brunel@diku.dk> (Julien Brunel's message of
	"Thu, 7 Aug 2008 17:15:53 +0200")
Message-ID: <ada3algrgrm.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Aug 2008 15:23:10.0098 (UTC) FILETIME=[80003720:01C8F8A1]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

good stuff, applied.  thanks.
