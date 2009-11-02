Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbZKBPyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbZKBPyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbZKBPyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:54:04 -0500
Received: from cantor.suse.de ([195.135.220.2]:34545 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143AbZKBPyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:54:03 -0500
Date: Mon, 2 Nov 2009 16:54:07 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: fix a typo in SHM_SIGNAL config description
In-Reply-To: <1256938012-8088-1-git-send-email-cascardo@holoscopio.com>
Message-ID: <alpine.LSU.2.00.0911021653250.4203@wotan.suse.de>
References: <1256938012-8088-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Oct 2009, Thadeu Lima de Souza Cascardo wrote:

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  lib/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 272cecf..bfe871d 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -207,7 +207,7 @@ config SHM_SIGNAL
>  	tristate "SHM Signal - Generic shared-memory signaling mechanism"
>  	default n
>  	help
> -	 Provides a shared-memory based signaling mechansim to indicate
> +	 Provides a shared-memory based signaling mechanism to indicate
>           memory-dirty notifications between two end-points.
>  
>  	 If unsure, say N

This doesn't apply on top of current Linus' tree. Gregory, I guess you'll 
be taking this one together with your pile that's currently in -next, 
right?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
