Return-Path: <linux-kernel-owner+w=401wt.eu-S1761114AbYFXOUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761114AbYFXOUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbYFXOT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:19:56 -0400
Received: from www.tglx.de ([62.245.132.106]:44698 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760014AbYFXOTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:19:55 -0400
Date: Tue, 24 Jun 2008 16:19:38 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Mike Frysinger <vapier@gentoo.org>
Cc: hjk@linutronix.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       gregkh@suse.de
Subject: Re: [PATCH] uio-howto.tmpl: use unique output names
Message-ID: <20080624141938.GC3217@local>
References: <1214191128-27114-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214191128-27114-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Added GregKH to Cc:)

On Sun, Jun 22, 2008 at 11:18:48PM -0400, Mike Frysinger wrote:
> The Userspace I/O HOWTO template sets two different sections with the same
> html output name (about.html).  This clearly won't work, so change the first
> one to a unique "aboutthis.html" to prevent clobbering.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

> ---
>  Documentation/DocBook/uio-howto.tmpl |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
> index 3da4855..d38fbde 100644
> --- a/Documentation/DocBook/uio-howto.tmpl
> +++ b/Documentation/DocBook/uio-howto.tmpl
> @@ -69,7 +69,7 @@ GPL version 2.
>  </bookinfo>
>  
>  <chapter id="aboutthisdoc">
> -<?dbhtml filename="about.html"?>
> +<?dbhtml filename="aboutthis.html"?>
>  <title>About this document</title>
>  
>  <sect1 id="translations">
> -- 
> 1.5.5.3
