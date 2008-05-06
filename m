Return-Path: <linux-kernel-owner+w=401wt.eu-S1765356AbYEFU55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765356AbYEFU55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764980AbYEFU5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:57:39 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:40167 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764787AbYEFU5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:57:37 -0400
X-Greylist: delayed 34774 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 May 2008 16:57:36 EDT
Date: Tue, 6 May 2008 22:57:31 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: monstr@seznam.cz
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>, arnd@arndb.de,
       linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 46/56] microblaze_v2: headers files entry.h current.h
 mman.h registers.h sembuf.h
In-Reply-To: <5b1319d426b1f55e08402790b4bc16a33ec7c00c.1209897267.git.monstr@monstr.eu>
Message-ID: <Pine.LNX.4.64.0805062256110.6341@anakin>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <96f2004535c34a0c762bf2012c299cbf9f89ab32.1209897266.git.monstr@monstr.eu>
 <92cd3a27b393bb394d48902594152351a92c59bb.1209897266.git.monstr@monstr.eu>
 <4e20213f5f296268a24955df8c951f7fba279816.1209897266.git.monstr@monstr.eu>
 <49eccf3408b90a5ebb42635493bbeef3b584acb9.1209897266.git.monstr@monstr.eu>
 <d1e4a572d2add458e1dc7c4f5a3039ae4faa2c04.1209897266.git.monstr@monstr.eu>
 <27d6acda14c492aae35d8bb1343a122624560418.1209897266.git.monstr@monstr.eu>
 <64e6fc7378cd5c714fcceef7d4965c1fb3d1b288.1209897266.git.monstr@monstr.eu>
 <9cc0d54a98f25748dc3f16fc3250524d7cd00877.1209897266.git.monstr@monstr.eu>
 <5d240127ee05c28d5156bfbf305329f9540f6c14.1209897267.git.monstr@monstr.eu>
 <59b5238f7a259dcac4c9ca6513756a188625462e.1209897267.git.monstr@monstr.eu>
 <8e1d421649250f7a3f638cd552bc46e5f5845890.1209897267.git.monstr@monstr.eu>
 <5b1319d426b1f55e08402790b4bc16a33ec7c00c.1209897267.git.monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 May 2008, monstr@seznam.cz wrote:
> --- /dev/null
> +++ b/include/asm-microblaze/sembuf.h
                    ^^^^^^^^^^
> + * The semid64_ds structure for m68k architecture.
                                   ^^^^
You also want to update these, to avoid triggering my attention ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
