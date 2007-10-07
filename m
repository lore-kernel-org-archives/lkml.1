Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbXJGPrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbXJGPrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 11:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbXJGPq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 11:46:58 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:52919 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbXJGPq5 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 11:46:57 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Oleg Verych <olecom@flower.upol.cz>, Ingo Molnar <mingo@elte.hu>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)"
In-Reply-To: Your message of "Sun, 07 Oct 2007 16:12:22 BST."
             <20071007161222.1b758f2f@the-village.bc.nu>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu> <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu> <20071007111035.GO22435@flower.upol.cz> <2614.1191766530@turing-police.cc.vt.edu>
            <20071007161222.1b758f2f@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1191771990_10413P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 07 Oct 2007 11:46:30 -0400
Message-ID: <7149.1191771990@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1191771990_10413P
Content-Type: text/plain; charset=us-ascii

(changing Subject: back again, since Alan's returning to that topic...)

On Sun, 07 Oct 2007 16:12:22 BST, Alan Cox said:

> What I would much rather people thought about was
> 
> - Marker modes for translation (so you know which bits of a message are
> formatted up)
> - More consistency on the use of "name: blah" to make it easier to parse
> - Turning more messages from kernel logs to events when it makes sense
> (eg "Disk Full", "Media Error", "CPU on fire")

What would it take to have a pointer chain at a *well known* location or
similar magic so if a machine died, I'd be able to hook up a laptop with a
FireWire cable and do firescope magic to extract at least/just the dmesg buffer?  

(Yes, I know this requires a 1394 port and some previous cooperation and setup
on the part of the 1394 driver. Assume I can get away with saying "add this
to your kernel command line to make debugging easier for me" ;)

(And yes, 5 years ago I'd have been wanting a "dump dmesg to floppy" patch,
but times move one and 1394 is more likely than a floppy now...)

--==_Exmh_1191771990_10413P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHCP9WcC3lWbTT17ARAqioAKCFxk5yOJg7MeTbePAKiwDMa8kVJwCgxWrn
OY53WUKtF9OnNgEnfwom4Rs=
=gILW
-----END PGP SIGNATURE-----

--==_Exmh_1191771990_10413P--
