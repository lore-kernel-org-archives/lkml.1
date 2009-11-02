Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbZKBIjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbZKBIjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 03:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZKBIjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 03:39:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53077 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbZKBIjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 03:39:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Chen Liqin <liqin.chen@sunplusct.com>
Subject: Re: [PATCH] asm-generic: Fix typo in asm-generic/unistd.h.
Date: Mon, 2 Nov 2009 09:39:14 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       liqin.gnu@gmail.com
References: <1256526569.7283.3.camel@ad3ser01>
In-Reply-To: <1256526569.7283.3.camel@ad3ser01>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911020939.15309.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/b6G98xqzbBPmx8w3+ufpY0XaJ3qSZfAzN9Mf
 +HCbkPv+iT8SF69iP1NMJLm9J/hCnV/laxdNVyePns5a/aCTrM
 Q4Wk+y+Z8yBAEJUjUl2qg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 October 2009, Chen Liqin wrote:
> >From 9741f7928ef35416e49f329a64e623a109de5c2d Mon Sep 17 00:00:00 2001
> From: Chen Liqin <liqin.chen@sunplusct.com>
> Date: Mon, 26 Oct 2009 10:50:50 +0800
> Subject: [PATCH] asm-generic: Fix typo in asm-generic/unistd.h.
> 
> Fixed __NR_ftruncate and __NR_ftruncate64 define in asm-generic/unistd.h.
> 
> Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>

Applied, thanks!

I assume that means you are progressing with getting all bugs fixed that
were introduced in the conversion to the asm-generic headers. Do you
have a full glibc running again, and passing LTP?

	Arnd <><
