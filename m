Return-Path: <linux-kernel-owner+w=401wt.eu-S932262AbXCCUiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbXCCUiv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 15:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932304AbXCCUiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 15:38:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:54868 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262AbXCCUiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 15:38:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: bryan.wu@analog.com
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
Date: Sat, 3 Mar 2007 21:38:49 +0100
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1172722480.5264.75.camel@roc-desktop>
In-Reply-To: <1172722480.5264.75.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703032138.49308.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:bf0b512fe2ff06b96d9695102898be39
X-Provags-ID2: V01U2FsdGVkX1/AgF4WvxHDlKVzVGZrKqa7ja3ru+3tGRz+Z3E
 uKCViSsf6IT7HEHOygSytBhUbZjvsDs9Ix9x4r7uWkcCb5ur6V
 xfO3Oj8X/9esfmHeYPpPA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2007 05:14:40 Wu, Bryan wrote:
> The whole patch is located at URL:
> https://blackfin.uclinux.org/gf/download/frsrelease/39/2583/blackfin-arch.p
>atch The incremental patch is located at URL:
> https://blackfin.uclinux.org/gf/download/frsrelease/39/2584/blackfin-arch-m
>m2-update.patch

I'm not sure if that was intentional, but the second patch does not apply
on top of the -mm kernel but rather patch the the patch old itself.
This basically makes it impossible to review just that part, so better
provide the diff between the kernel with the old patch and the kernel
with the new patch next time.

OTOH, from what I could see from the contents, the changes themselves
look pretty good, I'd probably add my 'Acked-by' if I could read that
patch more easily ;-)

	Arnd <><
