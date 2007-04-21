Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbXDUUzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbXDUUzo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 16:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbXDUUzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 16:55:44 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41084 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752652AbXDUUzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 16:55:44 -0400
Date: Sat, 21 Apr 2007 21:58:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>, kkeil@suse.de,
       i4ldeveloper@listserv.isdn4linux.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Remove "obsolete" label from ISDN4Linux (v3)
Message-ID: <20070421215844.542d3aab@the-village.bc.nu>
In-Reply-To: <462A0CA7.2090908@imap.cc>
References: <Pine.LNX.4.64.0701150634270.1953@CPE00045a9c397f-CM001225dbafb6>
	<45ABB53C.5030100@imap.cc>
	<Pine.LNX.4.64.0701151216310.7260@CPE00045a9c397f-CM001225dbafb6>
	<20070115172912.GA3323@pingi.kke.suse.de>
	<462A0CA7.2090908@imap.cc>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Apr 2007 15:07:51 +0200
Tilman Schmidt <tilman@imap.cc> wrote:

> From: Tilman Schmidt <tilman@imap.cc>
> 
> The "obsolete" label on the ISDN_I4L Kconfig option is not, and
> has never been, accurate. It has already prompted repeated attempts
> to remove actively used functionality from the kernel without a
> working replacement. This patch removes the incorrect label and
> corrects the accompanying help text.
> 
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>

Nak-by: Alan Cox <alan@redhat.com>

If it isn't obsolete then fix the code to use the newer APIs as its about
to end up && BROKEN let alone Obsolete. Make yourself maintainer and go
for it.
