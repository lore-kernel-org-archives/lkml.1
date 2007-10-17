Return-Path: <linux-kernel-owner+w=401wt.eu-S936589AbXJQCvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936589AbXJQCvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 22:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758607AbXJQCvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 22:51:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:50101 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765476AbXJQCvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 22:51:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,286,1188802800"; 
   d="scan'208";a="348241127"
Subject: Re: [PATCH] jiffies_round -> jiffies_round_relative conversion -
	ipw2100/ipw2200
From: Zhu Yi <yi.zhu@intel.com>
To: Anton Blanchard <anton@samba.org>,
       "John W.Linville" <linville@tuxdriver.com>
Cc: jketreno@linux.intel.com, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20071015053801.GB3257@kryten>
References: <20071015053428.GA3257@kryten>  <20071015053801.GB3257@kryten>
Content-Type: text/plain
Organization: Intel Corp.
Date: Wed, 17 Oct 2007 10:40:06 +0800
Message-Id: <1192588806.2992.7.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-15 at 00:38 -0500, Anton Blanchard wrote:
> 
> When rounding a relative timeout we need to use
> round_jiffies_relative(). 

ACK.

John, please apply this patch to wireless-2.6. Thanks.

-yi
