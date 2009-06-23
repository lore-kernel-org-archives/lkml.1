Return-Path: <linux-kernel-owner+w=401wt.eu-S1757143AbZFWKJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbZFWKJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 06:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbZFWKJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 06:09:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbZFWKJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 06:09:41 -0400
Date: Tue, 23 Jun 2009 12:09:43 +0200 (CEST)
From: Jiri Kosina <trivial@kernel.org>
X-X-Sender: jkosina@wotan.suse.de
To: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix a typo in linux/workqueue.h
In-Reply-To: <1245748897-24912-1-git-send-email-dmitri.vorobiev@movial.com>
Message-ID: <alpine.LNX.2.00.0906231209210.7457@wotan.suse.de>
References: <1245748897-24912-1-git-send-email-dmitri.vorobiev@movial.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Dmitri Vorobiev wrote:

> Change "useing" -> "using".
> 
> Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
> ---
>  include/linux/workqueue.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> index 13e1adf..f3a61fd 100644
> --- a/include/linux/workqueue.h
> +++ b/include/linux/workqueue.h
> @@ -94,7 +94,7 @@ struct execute_work {
>  /*
>   * initialize all of a work item in one go
>   *
> - * NOTE! No point in using "atomic_long_set()": useing a direct
> + * NOTE! No point in using "atomic_long_set()": using a direct
>   * assignment of the work data initializer allows the compiler
>   * to generate better code.
>   */

Applied to trivial queue, thanks Dmitri.

-- 
Jiri Kosina
SUSE Labs

