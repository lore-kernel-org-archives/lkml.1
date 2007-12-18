Return-Path: <linux-kernel-owner+w=401wt.eu-S933032AbXLRHHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbXLRHHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 02:07:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbXLRHHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 02:07:35 -0500
Received: from colo.lackof.org ([198.49.126.79]:58469 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbXLRHHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 02:07:34 -0500
Date: Tue, 18 Dec 2007 00:07:09 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Kyle McMartin <kyle@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-parisc@vger.kernel.org
Subject: Re: [PATCH] include/asm-parisc/: Spelling fixes
Message-ID: <20071218070709.GB6570@colo.lackof.org>
References: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,
Please include in -mm. "Cosmetic" - but I appreciate correct spelling too.

On Mon, Dec 17, 2007 at 11:30:11AM -0800, Joe Perches wrote:
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Signed-off-by: Grant Grundler <grundler@parisc-linux.org>

thanks,
grant

> ---
>  include/asm-parisc/elf.h     |    2 +-
>  include/asm-parisc/linkage.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/asm-parisc/elf.h b/include/asm-parisc/elf.h
> index f628ac7..8e7946a 100644
> --- a/include/asm-parisc/elf.h
> +++ b/include/asm-parisc/elf.h
> @@ -28,7 +28,7 @@
>  #define EFA_PARISC_1_1		    0x0210 /* PA-RISC 1.1 big-endian.  */
>  #define EFA_PARISC_2_0		    0x0214 /* PA-RISC 2.0 big-endian.  */
>  
> -/* Additional section indeces.  */
> +/* Additional section indices.  */
>  
>  #define SHN_PARISC_ANSI_COMMON	0xff00	   /* Section for tenatively declared
>  					      symbols in ANSI C.  */
> diff --git a/include/asm-parisc/linkage.h b/include/asm-parisc/linkage.h
> index ad8cd0d..0b19a72 100644
> --- a/include/asm-parisc/linkage.h
> +++ b/include/asm-parisc/linkage.h
> @@ -8,7 +8,7 @@
>  
>  /*
>   * In parisc assembly a semicolon marks a comment while a
> - * exclamation mark is used to seperate independent lines.
> + * exclamation mark is used to separate independent lines.
>   */
>  #ifdef __ASSEMBLY__
>  
> -- 
> 1.5.3.7.949.g2221a6
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-parisc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
