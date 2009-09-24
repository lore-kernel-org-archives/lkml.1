Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbZIXSJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbZIXSJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 14:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbZIXSJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 14:09:05 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:50954 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbZIXSJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 14:09:04 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2009 14:09:04 EDT
X-IronPort-AV: E=Sophos;i="4.44,446,1249257600"; 
   d="scan'208";a="44026704"
From: Roland Dreier <rdreier@cisco.com>
To: Julia Lawall <julia@diku.dk>
Cc: hal.rosenstock@gmail.com, Sean Hefty <sean.hefty@intel.com>,
       Roland Dreier <rolandd@cisco.com>,
       Chien Tung <chien.tin.tung@intel.com>,
       Faisal Latif <faisal.latif@intel.com>, linux-rdma@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/5] drivers/infiniband: remove duplicate structure field initialization
References: <Pine.LNX.4.64.0909192149040.27171@ask.diku.dk>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 24 Sep 2009 10:59:41 -0700
In-Reply-To: <Pine.LNX.4.64.0909192149040.27171@ask.diku.dk> (Julia Lawall's
	message of "Sat, 19 Sep 2009 21:49:24 +0200 (CEST)")
Message-ID: <aday6o41awi.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Sep 2009 17:59:41.0644 (UTC) FILETIME=[CA6728C0:01CA3D40]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
