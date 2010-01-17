Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083Ab0AQVpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab0AQVpj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 16:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813Ab0AQVpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 16:45:38 -0500
Received: from cantor.suse.de ([195.135.220.2]:35741 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab0AQVph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 16:45:37 -0500
Date: Sun, 17 Jan 2010 22:45:36 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Subject: Re: [PATCH] trivial: fix typo s/Defaultd/Defaults/ in EISA
 documentation
In-Reply-To: <1263763653-9774-1-git-send-email-cascardo@holoscopio.com>
Message-ID: <alpine.LNX.2.00.1001172245310.30977@pobox.suse.cz>
References: <1263763653-9774-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jan 2010, Thadeu Lima de Souza Cascardo wrote:

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  Documentation/eisa.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/eisa.txt b/Documentation/eisa.txt
> index 60e361b..f297fc1 100644
> --- a/Documentation/eisa.txt
> +++ b/Documentation/eisa.txt
> @@ -171,7 +171,7 @@ device.
>  virtual_root.force_probe :
>  
>  Force the probing code to probe EISA slots even when it cannot find an
> -EISA compliant mainboard (nothing appears on slot 0). Defaultd to 0
> +EISA compliant mainboard (nothing appears on slot 0). Defaults to 0
>  (don't force), and set to 1 (force probing) when either
>  CONFIG_ALPHA_JENSEN or CONFIG_EISA_VLB_PRIMING are set.

Applied.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
