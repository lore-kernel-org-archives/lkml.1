Return-Path: <linux-kernel-owner+w=401wt.eu-S935880AbXGUDZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935880AbXGUDZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 23:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758557AbXGUDZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 23:25:34 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:52801 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758273AbXGUDZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 23:25:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAKcZoUarR7PE/2dsb2JhbAA
X-IronPort-AV: i="4.16,565,1175497200"; 
   d="scan'208"; a="505618810:sNHT22680936"
To: Florin Malita <fmalita@gmail.com>
Cc: rolandd@cisco.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] infiniband mlx4: potential leaks in __mlx4_ib_modify_qp
X-Message-Flag: Warning: May contain useful information
References: <469FC251.5020109@gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 20 Jul 2007 20:25:32 -0700
In-Reply-To: <469FC251.5020109@gmail.com> (Florin Malita's message of "Thu, 19 Jul 2007 15:58:09 -0400")
Message-ID: <ada1wf2a15f.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Jul 2007 03:25:32.0488 (UTC) FILETIME=[CB741480:01C7CB46]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
