Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbYIBU1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbYIBU1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 16:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbYIBU0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 16:26:55 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:56166 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbYIBU0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 16:26:54 -0400
X-IronPort-AV: E=Sophos;i="4.32,319,1217808000"; 
   d="scan'208";a="71961579"
From: Roland Dreier <rdreier@cisco.com>
To: Julien Brunel <brunel@diku.dk>
Cc: rolandd@cisco.com, sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/infiniband/core: Use a NULL test rather than an IS_ERR test
References: <200808281531.07942.brunel@diku.dk>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 02 Sep 2008 13:26:51 -0700
In-Reply-To: <200808281531.07942.brunel@diku.dk> (Julien Brunel's message of
	"Thu, 28 Aug 2008 15:31:07 +0200")
Message-ID: <adasksifg50.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Sep 2008 20:26:52.0107 (UTC) FILETIME=[3BE7A1B0:01C90D3A]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
