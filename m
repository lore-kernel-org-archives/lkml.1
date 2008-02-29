Return-Path: <linux-kernel-owner+w=401wt.eu-S933389AbYB2Vaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389AbYB2Vaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933423AbYB2V3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:29:33 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:47354 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933281AbYB2V3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:29:31 -0500
X-IronPort-AV: E=Sophos;i="4.25,429,1199692800"; 
   d="scan'208";a="15414191"
To: Pete Wyckoff <pw@osc.edu>
Cc: Olaf Kirch <olaf.kirch@oracle.com>, general@lists.openfabrics.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert "IB/fmr_pool: ib_fmr_pool_flush() should flush all dirty FMRs"
X-Message-Flag: Warning: May contain useful information
References: <20080225225330.GA3316@osc.edu> <ada1w70zlkf.fsf@cisco.com>
	<20080226182655.GD7033@osc.edu> <20080226182731.GE7033@osc.edu>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 29 Feb 2008 13:29:27 -0800
In-Reply-To: <20080226182731.GE7033@osc.edu> (Pete Wyckoff's message of "Tue, 26 Feb 2008 13:27:31 -0500")
Message-ID: <ada8x13v4co.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Feb 2008 21:29:27.0343 (UTC) FILETIME=[295DABF0:01C87B1A]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
