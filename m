Return-Path: <linux-kernel-owner+w=401wt.eu-S1758966AbXIJRhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbXIJRhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 13:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbXIJRhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 13:37:33 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36085 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754877AbXIJRhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 13:37:32 -0400
Date: Mon, 10 Sep 2007 18:44:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Adrian Bunk <bunk@kernel.org>, perex@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-ID: <20070910184454.6c2a8ab9@the-village.bc.nu>
In-Reply-To: <20070910102556.de35e825.akpm@linux-foundation.org>
References: <20070909202527.GT3563@stusta.de>
	<20070909203920.GA11764@infradead.org>
	<20070909145940.0b41c8a5.akpm@linux-foundation.org>
	<20070910090808.GA31204@infradead.org>
	<20070910022324.c69e1897.akpm@linux-foundation.org>
	<20070910124358.GB21089@ftp.linux.org.uk>
	<20070910102556.de35e825.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> A single kernel release seems sufficient.  It gives the maintainers of such
> code time to hear about the breakage and time to fix it.

Users don't report warnings generally. They won't even see modprobe
warnings or anything in dmesg. Short of using their sound card to scream
"Next release you are screwed" they won't notice (and if you the sound
card trick they'll think they got rooted....)

Alan
