Return-Path: <linux-kernel-owner+w=401wt.eu-S1761433AbZEGCUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433AbZEGCUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 22:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbZEGCUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 22:20:32 -0400
Received: from smtp.nokia.com ([192.100.122.233]:21137 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbZEGCUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 22:20:30 -0400
To: ext Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Bob Copeland <me@bobcopeland.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       "linux-next\@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH next-20090506] wireless: WL12XX should depend on GENERIC_HARDIRQS
References: <Pine.LNX.4.64.0905062229370.23257@anakin>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 07 May 2009 05:19:21 +0300
In-Reply-To: <Pine.LNX.4.64.0905062229370.23257@anakin> (ext Geert Uytterhoeven's message of "Wed\, 6 May 2009 22\:35\:58 +0200")
Message-ID: <871vr1bqom.fsf@nokia.com>
User-Agent: Gnus/5.101 (Gnus v5.10.10) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 May 2009 02:19:27.0329 (UTC) FILETIME=[3F04D510:01C9CEBA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Geert Uytterhoeven <geert@linux-m68k.org> writes:

> m68k allmodconfig:
> | drivers/net/wireless/wl12xx/main.c: In function 'wl12xx_probe':
> | drivers/net/wireless/wl12xx/main.c:1273: error: implicit declaration of function 'set_irq_type'
> | make[1]: *** [drivers/net/wireless/wl12xx/main.o] Error 1
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Kalle Valo <kalle.valo@nokia.com>

-- 
Kalle Valo
