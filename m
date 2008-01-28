Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbYA1Fck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbYA1Fck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 00:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbYA1Fcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 00:32:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45620 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbYA1Fcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 00:32:31 -0500
Date: Sun, 27 Jan 2008 21:32:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/14] M68k patches for 2.6.25
Message-Id: <20080127213240.8933a000.akpm@linux-foundation.org>
In-Reply-To: <20080127123216.897698766@mail.of.borg>
References: <20080127123216.897698766@mail.of.borg>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2008 13:32:16 +0100 Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> 	Hi Linus, Andrew,
> 
> Here are the m68k patches I had queued up for 2.6.25:
>   [1] m68k: Use cc-cross-prefix
>   [2] m68k: ARRAY_SIZE() cleanup
>   [3] dio: ARRAY_SIZE() cleanup
>   [4] m68k: Balance ioremap and iounmap in m68k/atari/hades-pci.c
>   [5] nubus: kill drivers/nubus/nubus_syms.c
>   [6] m68k: kill arch/m68k/mac/mac_ksyms.c
>   [7] m68k: kill arch/m68k/hp300/ksyms.c
>   [8] m68k: kill arch/m68k/amiga/amiga_ksyms.c
>   [9] m68k: kill arch/m68k/atari/atari_ksyms.c
>   [10] m68k: kill arch/m68k/mvme16x/mvme16x_ksyms.c
>   [11] mac68k: macii adb comment correction
>   [12] mac68k: remove dead code
>   [13] mac68k: add nubus card definitions and a typo fix
>   [14] mac68k: remove dead MAC_ADBKEYCODES
> 

I already have these merged and queued.  Hopefully none of them have
changed.
