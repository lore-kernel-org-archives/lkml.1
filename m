Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbZF2HpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbZF2HpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 03:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZF2HpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 03:45:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:38639 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbZF2HpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 03:45:08 -0400
Date: Mon, 29 Jun 2009 09:45:07 +0200 (CEST)
From: Jiri Kosina <trivial@kernel.org>
X-X-Sender: jkosina@wotan.suse.de
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KERNEL:  Correct routine name in comment.
In-Reply-To: <alpine.LFD.2.00.0906282109240.25795@localhost>
Message-ID: <alpine.LNX.2.00.0906290944400.18021@wotan.suse.de>
References: <alpine.LFD.2.00.0906282109240.25795@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jun 2009, Robert P. J. Day wrote:

> 
> Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> 
> ---
> 
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 984b3ec..b855012 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -177,7 +177,7 @@ static const struct tnt tnts[] = {
>   *  'W' - Taint on warning.
>   *  'C' - modules from drivers/staging are loaded.
>   *
> - *	The string is overwritten by the next call to print_taint().
> + *	The string is overwritten by the next call to print_tainted().
>   */

Applied to trivial queue, thanks.

-- 
Jiri Kosina
SUSE Labs

