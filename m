Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbYGYCDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbYGYCDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 22:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbYGYCDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 22:03:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:26339 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbYGYCDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 22:03:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,250,1215414000"; 
   d="scan'208";a="600783505"
Subject: Re: [ipw3945-devel] [PATCH] iwlwifi: Enable packet injection for
	iwl4965
From: Zhu Yi <yi.zhu@intel.com>
To: =?ISO-8859-1?Q?St=E9phane?= Jourdois <stephane@jourdois.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org,
       ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <4886235F.6010407@jourdois.fr>
References: <69e28c910807181205m6dd0cdcek83f9717bf1ac9dcc@mail.gmail.com>
	 <69e28c910807220454q7c8371e1m11b1015ed8398758@mail.gmail.com>
	 <4885DDC4.2060609@googlemail.com>  <4886235F.6010407@jourdois.fr>
Content-Type: text/plain; charset=GB2312
Organization: Intel Corp.
Date: Fri, 25 Jul 2008 09:58:53 +0800
Message-Id: <1216951133.2705.227.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-22 at 20:13 +0200, St¨¦phane Jourdois wrote:
> but this commit is for iwl3945, not iwl4965.
> The patch for iwl4965 is currently not in any git tree.

We are waiting for more "confirmed success" response before merging it.

Thanks,
-yi

