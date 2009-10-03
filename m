Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbZJCIQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbZJCIQD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 04:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbZJCIQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 04:16:02 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:49650 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbZJCIQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 04:16:00 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 3 Oct 2009 10:15:41 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] Update the e-mail for the userspace tools to use
 ohci1394_dma=early for debugging.
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <1254262438-31323-2-git-send-email-justinmattock@gmail.com>
Message-ID: <tkrat.f4970b0de587f089@s5r6.in-berlin.de>
References: <1254262438-31323-1-git-send-email-justinmattock@gmail.com>
 <1254262438-31323-2-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 Sep, Justin P. Mattock wrote:
> ---
>  Documentation/debugging-via-ohci1394.txt |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/debugging-via-ohci1394.txt b/Documentation/debugging-via-ohci1394.txt
> index 59a91e5..8be3c78 100644
> --- a/Documentation/debugging-via-ohci1394.txt
> +++ b/Documentation/debugging-via-ohci1394.txt
> @@ -64,14 +64,14 @@ be used to view the printk buffer of a remote machine, even with live update.
>  
>  Bernhard Kaindl enhanced firescope to support accessing 64-bit machines
>  from 32-bit firescope and vice versa:
> -- ftp://ftp.suse.de/private/bk/firewire/tools/firescope-0.2.2.tar.bz2
> +- http://halobates.de/firewire/firescope-0.2.2.tar.bz2
>  
>  and he implemented fast system dump (alpha version - read README.txt):
> -- ftp://ftp.suse.de/private/bk/firewire/tools/firedump-0.1.tar.bz2
> +- http://halobates.de/firewire/firedump-0.1.tar.bz2
>  
>  There is also a gdb proxy for firewire which allows to use gdb to access
>  data which can be referenced from symbols found by gdb in vmlinux:
> -- ftp://ftp.suse.de/private/bk/firewire/tools/fireproxy-0.33.tar.bz2
> +- http://halobates.de/firewire/fireproxy-0.33.tar.bz2
>  
>  The latest version of this gdb proxy (fireproxy-0.34) can communicate (not
>  yet stable) with kgdb over an memory-based communication module (kgdbom).
> @@ -178,7 +178,7 @@ Step-by-step instructions for using firescope with early OHCI initialization:
>  
>  Notes
>  -----
> -Documentation and specifications: ftp://ftp.suse.de/private/bk/firewire/docs
> +Documentation and specifications: http://halobates.de/firewire/ 
>  
>  FireWire is a trademark of Apple Inc. - for more information please refer to:
>  http://en.wikipedia.org/wiki/FireWire

I don't see this patch in linux-next yet, hence I picked it up committed
it to linux1394-2.6.git.
-- 
Stefan Richter
-=====-==--= =-=- ---==
http://arcgraph.de/sr/

