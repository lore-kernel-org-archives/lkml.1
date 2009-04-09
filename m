Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbZDIMPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbZDIMPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 08:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759661AbZDIMPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 08:15:35 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:48821 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759626AbZDIMPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 08:15:34 -0400
X-Greylist: delayed 2181 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Apr 2009 08:15:34 EDT
From: Dmitry Gryazin <gdu@mns.spb.ru>
Organization: MNS
To: navy-patches@dinar.mns.mnsspb.ru
Subject: Re: [Navy-patches] [PATCH] Makefile: fix few typos
Date: Thu, 9 Apr 2009 15:38:09 +0400
User-Agent: KMail/1.9.9
Cc: Kirill Smelkov <kirr@mns.spb.ru>, Sam Ravnborg <sam@ravnborg.org>,
       navy-patches@mns.spb.ru, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
References: <1239276874-2141-1-git-send-email-kirr@mns.spb.ru>
In-Reply-To: <1239276874-2141-1-git-send-email-kirr@mns.spb.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904091538.09703.gdu@mns.spb.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 April 2009 03:34:34 pm Kirill Smelkov wrote:
> Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
> ---
>  Makefile |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index e5ad5fd..3e95d45 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -567,7 +567,7 @@ KBUILD_CFLAGS += $(call
> cc-option,-Wdeclaration-after-statement,) # disable pointer signed /
> unsigned warnings in gcc 4.0
>  KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
>
> -# disable invalid "can't wrap" optimzations for signed / pointers
> +# disable invalid "can't wrap" optimizations for signed / pointers
>  KBUILD_CFLAGS	+= $(call cc-option,-fwrapv)
>
>  # revert to pre-gcc-4.4 behaviour of .eh_frame
> @@ -1587,5 +1587,5 @@ PHONY += FORCE
>  FORCE:
>
>  # Declare the contents of the .PHONY variable as phony.  We keep that
> -# information in a variable se we can use it in if_changed and friends.
> +# information in a variable so we can use it in if_changed and friends.
>  .PHONY: $(PHONY)

ACK
