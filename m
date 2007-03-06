Return-Path: <linux-kernel-owner+w=401wt.eu-S933291AbXCFTsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291AbXCFTsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 14:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933299AbXCFTsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 14:48:30 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:7638 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291AbXCFTs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 14:48:29 -0500
X-IronPort-AV: i="4.14,255,1170662400"; 
   d="scan'208"; a="397701659:sNHT43952370"
To: Steve Wise <swise@opengridcomputing.com>
Cc: Netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       General@lists.openfabrics.org
Subject: Re: [ofa-general] [PATCH 2.6.21-rc2] iw_cxgb3: Don't use mm after its freed in iwch_mmap().
X-Message-Flag: Warning: May contain useful information
References: <1172873196.21241.62.camel@stevo-desktop>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 06 Mar 2007 11:48:27 -0800
In-Reply-To: <1172873196.21241.62.camel@stevo-desktop> (Steve Wise's message of "Fri, 02 Mar 2007 16:06:36 -0600")
Message-ID: <ada8xeanofo.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Mar 2007 19:48:27.0371 (UTC) FILETIME=[68A153B0:01C76028]
Authentication-Results: sj-dkim-5; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim5002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied.
