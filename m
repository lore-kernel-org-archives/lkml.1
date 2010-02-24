Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab0BXSYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 13:24:22 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:50315 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461Ab0BXSYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 13:24:21 -0500
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMr9hEurRN+J/2dsb2JhbACbEHOkBZhHhHIEgxY
X-IronPort-AV: E=Sophos;i="4.49,533,1262563200"; 
   d="scan'208";a="302512752"
From: Roland Dreier <rdreier@cisco.com>
To: Alex Chiang <achiang@hp.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 18/18] IB/core: pack struct ib_device a little tighter
References: <20100202185235.28217.64521.stgit@bob.kio>
	<20100202190916.28217.90954.stgit@bob.kio>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 24 Feb 2010 10:24:17 -0800
In-Reply-To: <20100202190916.28217.90954.stgit@bob.kio> (Alex Chiang's message
	of "Tue, 02 Feb 2010 12:09:16 -0700")
Message-ID: <adaeika1oha.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied all 18, thanks a lot Alex.  You really made the review easy by
splitting this up nicely...

 - R.
-- 
Roland Dreier  <rolandd@cisco.com>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
