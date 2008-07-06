Return-Path: <linux-kernel-owner+w=401wt.eu-S1758859AbYGFUjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859AbYGFUjJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 16:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757051AbYGFUi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 16:38:56 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:33023 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385AbYGFUiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 16:38:55 -0400
Date: Sun, 6 Jul 2008 22:38:51 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 4
In-Reply-To: <20080704195529.7f56e768.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0807062236460.5733@anakin>
References: <20080704195529.7f56e768.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2008, Stephen Rothwell wrote:
> There are several outstanding build failures due to structural changes in
> the ttydev tree (see http://kisskb.ellerman.id.au/linux-next).

Do we really want these (obviously unfinished) structural changes in the
linux-next tree already? They keep on breaking several architectures since
several days?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
