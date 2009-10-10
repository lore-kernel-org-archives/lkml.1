Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbZJJGe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbZJJGe1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 02:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbZJJGe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 02:34:26 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:51798 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbZJJGe0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 02:34:26 -0400
MIME-Version: 1.0
In-Reply-To: <774db7b9d6083108e254a3c8bbdb17251bf3b45c.1255153863.git.joe@perches.com>
References: <cover.1255153863.git.joe@perches.com> <774db7b9d6083108e254a3c8bbdb17251bf3b45c.1255153863.git.joe@perches.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 10 Oct 2009 00:33:29 -0600
X-Google-Sender-Auth: 97cb00c288474285
Message-ID: <fa686aa40910092333v12f66ef0l4ef6cdd5e1e59f7d@mail.gmail.com>
Subject: Re: [PATCH 3/3] MAINTAINERS: Add OPEN FIRMWARE DEVICE TREE section
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10, 2009 at 12:05 AM, Joe Perches <joe@perches.com> wrote:
> Added L: mailing list, W: wiki and K: of_get_property keyword
>
> Signed-off-by: Joe Perches <joe@perches.com>

NACK.  But only because I've also got a conflicting patch that adds
the same entry (without the W or K tags).  I'll merge this with that
and post right now.  :-)

g.

> ---
>  MAINTAINERS |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4407de2..a88ea6b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3884,6 +3884,12 @@ S:       Maintained
>  F:     Documentation/i2c/busses/i2c-ocores
>  F:     drivers/i2c/busses/i2c-ocores.c
>
> +OPEN FIRMWARE DEVICE TREE
> +L:     devicetree-discuss@lists.ozlabs.org
> +W:     http://fdt.secretlab.ca/Main_Page
> +S:     Odd Fixes
> +K:     of_get_property
-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
