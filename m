Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab0BXMpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 07:45:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab0BXMpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 07:45:08 -0500
Date: Wed, 24 Feb 2010 13:45:05 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       linux-doc@vger.kernel.org
Subject: Re: [PATCH] doc: console doc should read "bind & unbind" instead of
 "bind & bind"
In-Reply-To: <1265047036-7402-1-git-send-email-cascardo@holoscopio.com>
Message-ID: <alpine.LNX.2.00.1002241344560.30967@pobox.suse.cz>
References: <1265047036-7402-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Feb 2010, Thadeu Lima de Souza Cascardo wrote:

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  Documentation/console/console.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/console/console.txt b/Documentation/console/console.txt
> index 877a1b2..926cf1b 100644
> --- a/Documentation/console/console.txt
> +++ b/Documentation/console/console.txt
> @@ -74,7 +74,7 @@ driver takes over the consoles vacated by the driver. Binding, on the other
>  hand, will bind the driver to the consoles that are currently occupied by a
>  system driver.
>  
> -NOTE1: Binding and binding must be selected in Kconfig. It's under:
> +NOTE1: Binding and unbinding must be selected in Kconfig. It's under:
>  
>  Device Drivers -> Character devices -> Support for binding and unbinding
>  console drivers

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
