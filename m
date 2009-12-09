Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbZLISFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbZLISFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbZLISFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:05:45 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:37246 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499AbZLISFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:05:44 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.47,369,1257120000"; 
   d="scan'208";a="116887794"
From: Roland Dreier <rdreier@cisco.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Ralph Campbell <infinipath@qlogic.com>,
       Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] ipath: Use bitmap_weight
References: <1258340880-28269-1-git-send-email-akinobu.mita@gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 09 Dec 2009 10:05:49 -0800
In-Reply-To: <1258340880-28269-1-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Mon, 16 Nov 2009 12:08:00 +0900")
Message-ID: <ada638gt43m.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Dec 2009 18:05:50.0119 (UTC) FILETIME=[3D6CFB70:01CA78FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
