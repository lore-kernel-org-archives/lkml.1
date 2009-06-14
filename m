Return-Path: <linux-kernel-owner+w=401wt.eu-S1764684AbZFNUwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764684AbZFNUwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758388AbZFNUwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:52:13 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:34727 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757938AbZFNUwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:52:12 -0400
Date: Sun, 14 Jun 2009 22:54:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arne Janbu <arnej@ampheus.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Ignore *.lzma files
Message-ID: <20090614205431.GA4917@uranus.ravnborg.org>
References: <200906101825.10474.arnej@ampheus.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906101825.10474.arnej@ampheus.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 06:25:10PM +0200, Arne Janbu wrote:
> >From 71cc682035dacd31b11666edf910afb6a4201da4 Mon Sep 17 
> 00:00:00 2001
> From: Arne Janbu <arnej@ampheus.de>
> Date: Wed, 10 Jun 2009 17:16:42 +0200
> Subject: [PATCH] Add *.lzma to .gitignore
> 
> ---
>  .gitignore |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/.gitignore b/.gitignore
> index 51bd99d..faa8b4d 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -25,6 +25,7 @@
>  *.elf
>  *.bin
>  *.gz
> +*.lzma
>  
>  #
>  # Top-level generic files

Applied.
Please signoff any future patches.

Thanks,
	Sam
