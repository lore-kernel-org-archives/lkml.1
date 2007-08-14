Return-Path: <linux-kernel-owner+w=401wt.eu-S1760834AbXHNEEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760834AbXHNEEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 00:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbXHNEEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 00:04:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:59048 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbXHNEEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 00:04:23 -0400
Message-ID: <246a89290708132104h4145349ah4a4a56ef852a1bb3@mail.gmail.com>
Date: Mon, 13 Aug 2007 21:04:20 -0700
From: "Nathan Laredo" <laredo@gnu.org>
To: "joe@perches.com" <joe@perches.com>
Subject: Re: [PATCH] [463/2many] MAINTAINERS - STRADIS MPEG-2 DECODER DRIVER
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <46bffc01.7c95Dz5xUUkjysHI%joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bffc01.7c95Dz5xUUkjysHI%joe@perches.com>
X-Google-Sender-Auth: a95edb7e4626f000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Well, technically speaking, there are multiple files to the stradis
driver, not just stradis.c.

The tar file, http://kernel.org/pub/linux/kernel/people/laredo/stradis.tar.gz
should make clear which files originated in the stradis driver.

- Nathan Laredo
laredo@gnu.org

On 8/12/07, joe@perches.com <joe@perches.com> wrote:
> Add file pattern to MAINTAINER entry
>
> Signed-off-by: Joe Perches <joe@perches.com>
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9da5a44..3e51fc6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4406,6 +4406,7 @@ P:        Nathan Laredo
>  M:     laredo@gnu.org
>  W:     http://www.stradis.com/
>  S:     Maintained
> +F:     drivers/media/video/stradis.c
>
>  SUPERH (sh)
>  P:     Paul Mundt
>
