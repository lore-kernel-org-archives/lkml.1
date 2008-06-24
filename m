Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbYFXNnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbYFXNnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 09:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYFXNmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 09:42:54 -0400
Received: from www.tglx.de ([62.245.132.106]:42888 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbYFXNmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 09:42:53 -0400
Date: Tue, 24 Jun 2008 15:42:28 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Mike Frysinger <vapier@gentoo.org>
Cc: hjk@linutronix.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       gregkh@suse.de
Subject: Re: [PATCH] uio-howto.tmpl: use standard copyright/legal markings
Message-ID: <20080624134228.GB3217@local>
References: <1214304877-1223-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1214304877-1223-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Added GregKH to Cc:)

@Greg: Take care, the patch modifies a line with my name in it :-)

On Tue, Jun 24, 2008 at 06:54:37AM -0400, Mike Frysinger wrote:
> The Userspace I/O HOWTO document uses straight <sect1> tags and plain text
> to describe copyright/legal information.  It should instead use the
> <copyright> and <legalnotice> tags like all other documents in the kernel.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

> ---
>  Documentation/DocBook/uio-howto.tmpl |   23 ++++++++++++-----------
>  1 files changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
> index c4d1873..d799a26 100644
> --- a/Documentation/DocBook/uio-howto.tmpl
> +++ b/Documentation/DocBook/uio-howto.tmpl
> @@ -21,6 +21,18 @@
>      </affiliation>
>  </author>
>  
> +<copyright>
> +	<year>2006-2008</year>
> +	<holder>Hans-JÃŒrgen Koch.</holder>
> +</copyright>
> +
> +<legalnotice>
> +<para>
> +This documentation is Free Software licensed under the terms of the
> +GPL version 2.
> +</para>
> +</legalnotice>
> +
>  <pubdate>2006-12-11</pubdate>
>  
>  <abstract>
> @@ -66,17 +78,6 @@
>  <?dbhtml filename="about.html"?>
>  <title>About this document</title>
>  
> -<sect1 id="copyright">
> -<?dbhtml filename="copyright.html"?>
> -<title>Copyright and License</title>
> -<para>
> -      Copyright (c) 2006-2008 by Hans-JÃŒrgen Koch.</para>
> -<para>
> -This documentation is Free Software licensed under the terms of the
> -GPL version 2.
> -</para>
> -</sect1>
> -
>  <sect1 id="translations">
>  <?dbhtml filename="translations.html"?>
>  <title>Translations</title>
> -- 
> 1.5.5.3
