Return-Path: <linux-kernel-owner+w=401wt.eu-S1760685AbXKMS1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685AbXKMS1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbXKMS1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:27:19 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47990 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753179AbXKMS1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:27:18 -0500
Date: Tue, 13 Nov 2007 18:25:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mark Lord <liml@rtr.ca>,
       alsa-devel@alsa-project.org, netdev@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       Natalie Protasevich <protasnb@gmail.com>, linux-ide@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071113182516.250de873@the-village.bc.nu>
In-Reply-To: <20071113181053.GB1356@flint.arm.linux.org.uk>
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com>
	<20071113031553.3c7b5c16.akpm@linux-foundation.org>
	<4739ADA2.4060604@rtr.ca>
	<alpine.LFD.0.9999.0711131521590.3265@localhost.localdomain>
	<20071113181053.GB1356@flint.arm.linux.org.uk>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Given the wide range of ARM platforms today, it is utterly idiotic to
> expect a single person to be able to provide responses for all ARM bugs.
> I for one wish I'd never *VOLUNTEERED* to be a part of the kernel
> bugzilla, and really *WISH* I could pull out of that function.

You can. Perhaps that bugzilla needs to point to some kind of
arm-maintainers@vger.kernel.org list for the various ARM platform
maintainers ?

Alan
