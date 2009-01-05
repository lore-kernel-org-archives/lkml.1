Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbZAEUIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbZAEUIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZAEUH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:07:58 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:60827 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbZAEUH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:07:57 -0500
Date: Mon, 5 Jan 2009 21:07:54 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH] fix --build-id breakage for sun3
In-Reply-To: <20090105172810.GQ28946@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0901052107100.5451@anakin>
References: <20090105172810.GQ28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009, Al Viro wrote:
> Counterpart of commit 08a3db94f2a36c28278922732bc281c1722ceb18 for
> sun3 build.
> 
> Signet-off-by: Al Viro <viro@zeniv.linux.org.uk>
       ^
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks, applied to the m68k tree (with expanded referenced commit comment).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
