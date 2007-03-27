Return-Path: <linux-kernel-owner+w=401wt.eu-S965267AbXC0GRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965267AbXC0GRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 02:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965268AbXC0GRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 02:17:50 -0400
Received: from smtp.osdl.org ([65.172.181.24]:41614 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965267AbXC0GRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 02:17:49 -0400
Date: Mon, 26 Mar 2007 22:17:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       Takashi Iwai <tiwai@suse.de>, Ben Dooks <ben-linux@fluff.org>,
       Greg KH <greg@kroah.com>, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: Linux 2.6.21-rc5
Message-Id: <20070326221731.f4792260.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I have a few fixes here which belong to subsystem trees, which were missed
by the maintainers and which we probably want to get into 2.6.21.


ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/broken-out/make-aout-executables-work-again.patch

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/broken-out/revert-ac97-fix-microphone-and-line_in-selection-logic.patch

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/broken-out/drivers-mfd-sm501c-fix-an-off-by-one.patch

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/broken-out/pci-set-pci=bfsort-for-poweredge-r900.patch

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/broken-out/fix-sudden-warps-in-mousedev.patch

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/broken-out/fix-sysfs-rom-file-creation-for-bios-rom-shadows.patch

Maintainers are cc'ed.  Please promptly ack, nack or otherwise quack, else
I'll be making my own decisions ;)

