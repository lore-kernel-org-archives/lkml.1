Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbZEEH6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbZEEH6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 03:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbZEEH6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 03:58:14 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:56294 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbZEEH6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 03:58:13 -0400
Date: Tue, 5 May 2009 09:58:03 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alain Knaff <alain@knaff.lu>, "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: decompress_bunzip2.c is stack-hungry
Message-ID: <Pine.LNX.4.64.0905050957140.32385@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


http://kisskb.ellerman.id.au/kisskb/buildresult/407608/:
lib/decompress_bunzip2.c:509: warning: the frame size of 1888 bytes is larger than 1024 bytes

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
