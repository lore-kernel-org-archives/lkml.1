Return-Path: <linux-kernel-owner+w=401wt.eu-S1031239AbXEASbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031239AbXEASbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031238AbXEASbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:31:03 -0400
Received: from hoboe2bl1.telenet-ops.be ([195.130.137.73]:34045 "EHLO
	hoboe2bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031239AbXEASa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:30:59 -0400
X-Greylist: delayed 1366 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 May 2007 14:30:59 EDT
Date: Tue, 1 May 2007 20:30:56 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] AFS: Fix use of __exit functions from __init path
In-Reply-To: <20070501181706.28008.10566.stgit@warthog.cambridge.redhat.com>
Message-ID: <Pine.LNX.4.64.0705012030450.27246@anakin>
References: <20070501181706.28008.10566.stgit@warthog.cambridge.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, David Howells wrote:
> Fix use of __exit functions from __init path.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
