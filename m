Return-Path: <linux-kernel-owner+w=401wt.eu-S932849Ab0AFVQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab0AFVQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 16:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932676Ab0AFVQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 16:16:08 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:42720 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab0AFVQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 16:16:06 -0500
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAOKMREurR7Hu/2dsb2JhbADABZNghDAE
X-IronPort-AV: E=Sophos;i="4.49,231,1262563200"; 
   d="scan'208";a="285571071"
From: Roland Dreier <rdreier@cisco.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-rdma@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] INFINIBAND:  Correct CONFIG_IPv6 to CONFIG_IPV6.
References: <alpine.LFD.2.00.0912281644290.3429@localhost>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 06 Jan 2010 13:16:05 -0800
In-Reply-To: <alpine.LFD.2.00.0912281644290.3429@localhost> (Robert
	P. J. Day's message of "Mon, 28 Dec 2009 16:48:08 -0500 (EST)")
Message-ID: <adad41nszmy.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Jan 2010 21:16:05.0536 (UTC) FILETIME=[751C6200:01CA8F15]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied.

I think I added this error in the first place as part of the

    [ Fix up cma_check_linklocal() for !IPV6 case.  - Roland ]

"work" I did on the original commit d14714df.

 - R.
