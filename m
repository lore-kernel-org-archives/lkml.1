Return-Path: <linux-kernel-owner+w=401wt.eu-S1031435AbXHMNdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031435AbXHMNdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969601AbXHMJj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:39:27 -0400
Received: from ozlabs.org ([203.10.76.45]:44854 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S970422AbXHMJjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:39:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18112.9834.928005.997628@cargo.ozlabs.ibm.com>
Date: Mon, 13 Aug 2007 19:37:46 +1000
From: Paul Mackerras <paulus@samba.org>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [399/2many] MAINTAINERS - RAGE128 FRAMEBUFFER DISPLAY
 DRIVER
In-Reply-To: <46bffb7f.MBC+BLOxcxJusFcu%joe@perches.com>
References: <46bffb7f.MBC+BLOxcxJusFcu%joe@perches.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

joe@perches.com writes:

> @@ -3815,6 +3815,7 @@ P:	Paul Mackerras
>  M:	paulus@samba.org
>  L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
>  S:	Maintained
> +F:	drivers/video/aty/aty*

Actually, only drivers/video/aty/aty128fb.c for this entry.

Paul.
