Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbXFQMwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbXFQMwF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 08:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbXFQMvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 08:51:33 -0400
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:44066 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbXFQMvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 08:51:32 -0400
Message-Id: <20070617124704.800461751@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 17 Jun 2007 14:47:04 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>,
       Kars de Jong <jongk@linux-m68k.org>, Richard Hirst <rhirst@levanta.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Subject: [patch 0/5] m68k 53c700 SCSI
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi James,

These patches add support for m68k to the 53c700 SCSI core and introduce new
drivers for various m68k hardware using this 53c700 SCSI core, to replace the
just removed drivers using the old 53c7xx SCSI core.

  [1] [PATCH] 53c700 scsi: m68k support for the 53c700 SCSI core
  [2] [PATCH] 53c700 scsi: m68k BVME6000 NCR53C710 SCSI
  [3] [PATCH] 53c700 scsi: m68k MVME16x NCR53C710 SCSI
  [4] [PATCH] 53c700 scsi: Amiga 4000T NCR53c710 SCSI
  [5] [PATCH] 53c700 scsi: Amiga Zorro NCR53c710 SCSI

Please apply for 2.6.23. Thx!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

