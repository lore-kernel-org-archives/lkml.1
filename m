Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbZLIWbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbZLIWbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 17:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758041AbZLIWay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 17:30:54 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:26957 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054AbZLIWax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 17:30:53 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.47,370,1257120000"; 
   d="scan'208";a="447297740"
From: Roland Dreier <rdreier@cisco.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] IB/uverbs: PTR_ERR return of wrong pointer in ib_uverbs_get_context()
References: <4B1CFFBA.8060407@gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 09 Dec 2009 14:30:59 -0800
In-Reply-To: <4B1CFFBA.8060407@gmail.com> (Roel Kluin's message of "Mon, 07
	Dec 2009 14:14:34 +0100")
Message-ID: <ada7hsvrd98.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Dec 2009 22:30:59.0325 (UTC) FILETIME=[480D2AD0:01CA791F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well spotted, applied thanks.
