Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbZCBL7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbZCBL7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 06:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbZCBL7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 06:59:42 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:41497 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbZCBL7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 06:59:41 -0500
Date: Mon, 2 Mar 2009 11:56:35 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mmotm] remove pagevec_swap_free()
In-Reply-To: <20090301190227.6FDB.A69D9226@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0903021153070.30226@blonde.anvils>
References: <20090225192550.GA5645@cmpxchg.org> <Pine.LNX.4.64.0902252022460.19132@blonde.anvils>
 <20090301190227.6FDB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Mar 2009, KOSAKI Motohiro wrote:
> Subject: [PATCH] remove pagevec_swap_free()
> 
> pagevec_swap_free() is unused. 
> then it can be removed.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Following on from your patch to remove its use, yes.

Acked-by: Hugh Dickins <hugh@veritas.com>

Thanks,
Hugh
