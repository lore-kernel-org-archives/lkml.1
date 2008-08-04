Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbYHDSNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbYHDSNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbYHDSM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:12:59 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:19074 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbYHDSM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:12:58 -0400
X-IronPort-AV: E=Sophos;i="4.31,306,1215388800"; 
   d="scan'208";a="61282918"
From: Roland Dreier <rdreier@cisco.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: rolandd@cisco.com, sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Infiniband/ipath: fix warnings
References: <20080802102909.GC4856@orion>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 04 Aug 2008 11:12:50 -0700
In-Reply-To: <20080802102909.GC4856@orion> (Alexander Beregalov's message of
	"Sat, 2 Aug 2008 14:29:09 +0400")
Message-ID: <ada4p60tzrx.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Aug 2008 18:12:50.0896 (UTC) FILETIME=[B4FD7500:01C8F65D]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for doing this work, applied.
