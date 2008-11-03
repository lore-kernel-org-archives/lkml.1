Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbYKCFeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbYKCFeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 00:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbYKCFe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 00:34:27 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:22688 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbYKCFe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 00:34:26 -0500
X-IronPort-AV: E=Sophos;i="4.33,534,1220227200"; 
   d="scan'208";a="100884046"
From: Roland Dreier <rdreier@cisco.com>
To: =?utf-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: rolandd@cisco.com, general@lists.openfabrics.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/10] rdma/nes: reindent mis-indented spinlocks
References: <Pine.LNX.4.64.0810301307160.7072@wrl-59.cs.helsinki.fi>
	<Pine.LNX.4.64.0810301336130.7072@wrl-59.cs.helsinki.fi>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 02 Nov 2008 21:34:24 -0800
In-Reply-To: <Pine.LNX.4.64.0810301336130.7072@wrl-59.cs.helsinki.fi> ("Ilpo
	=?utf-8?Q?J=C3=A4rvinen=22's?= message of "Thu, 30 Oct 2008 13:39:43 +0200
 (EET)")
Message-ID: <adak5blwexr.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 Nov 2008 05:34:25.0119 (UTC) FILETIME=[D5062EF0:01C93D75]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied
