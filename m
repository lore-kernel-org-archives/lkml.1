Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbZGSNuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbZGSNuI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 09:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbZGSNuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 09:50:06 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:29803 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754217AbZGSNuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 09:50:05 -0400
X-Trace: 232512150/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.87.228/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.87.228
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar8FAKPBYkpPRVfk/2dsb2JhbACBUck2hAwF
X-IronPort-AV: E=Sophos;i="4.43,229,1246834800"; 
   d="scan'208";a="232512150"
Date: Sun, 19 Jul 2009 14:49:57 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Izik Eidus <ieidus@redhat.com>
cc: akpm@linux-foundation.org, hugh.dickins@tiscali.co.uk, aarcange@redhat.com,
       chrisw@redhat.com, avi@redhat.com, riel@redhat.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 09/10] ksm: change copyright message
In-Reply-To: <1247851850-4298-10-git-send-email-ieidus@redhat.com>
Message-ID: <Pine.LNX.4.64.0907191448200.4601@sister.anvils>
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com>
 <1247851850-4298-2-git-send-email-ieidus@redhat.com>
 <1247851850-4298-3-git-send-email-ieidus@redhat.com>
 <1247851850-4298-4-git-send-email-ieidus@redhat.com>
 <1247851850-4298-5-git-send-email-ieidus@redhat.com>
 <1247851850-4298-6-git-send-email-ieidus@redhat.com>
 <1247851850-4298-7-git-send-email-ieidus@redhat.com>
 <1247851850-4298-8-git-send-email-ieidus@redhat.com>
 <1247851850-4298-9-git-send-email-ieidus@redhat.com>
 <1247851850-4298-10-git-send-email-ieidus@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009, Izik Eidus wrote:
> From: Izik Eidus <ieidus@redhat.com>
> 
> Adding Hugh Dickins into the authors list.
> 
> Signed-off-by: Izik Eidus <ieidus@redhat.com>

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
with thanks!

> ---
>  mm/ksm.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index a0fbdb2..75d7802 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -4,11 +4,12 @@
>   * This code enables dynamic sharing of identical pages found in different
>   * memory areas, even if they are not shared by fork()
>   *
> - * Copyright (C) 2008 Red Hat, Inc.
> + * Copyright (C) 2008-2009 Red Hat, Inc.
>   * Authors:
>   *	Izik Eidus
>   *	Andrea Arcangeli
>   *	Chris Wright
> + *	Hugh Dickins
>   *
>   * This work is licensed under the terms of the GNU GPL, version 2.
>   */
> -- 
> 1.5.6.5
