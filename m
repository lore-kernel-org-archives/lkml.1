Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbXJGOQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbXJGOQJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 10:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbXJGOP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 10:15:57 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51648 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbXJGOP4 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 10:15:56 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: NAK nettiquete (was Re: "Re: [PATCH 0/2] Colored kernel output (run2)" 
In-Reply-To: Your message of "Sun, 07 Oct 2007 13:10:35 +0200."
             <20071007111035.GO22435@flower.upol.cz>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu> <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu>
            <20071007111035.GO22435@flower.upol.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1191766530_10413P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 07 Oct 2007 10:15:30 -0400
Message-ID: <2614.1191766530@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1191766530_10413P
Content-Type: text/plain; charset=us-ascii

On Sun, 07 Oct 2007 13:10:35 +0200, Oleg Verych said:

> > > I added comment (like this), so anyone can skip reading body, if 
> > > headers are "Oleg Verych && NAK". In case if `NAK' have a magic 
> > > meaning in the LKML, like control characters in the tty, i'm sorry.
> > 
> > yes, a 'NAK' has a particular meaning on lkml.
> 
> But what about (NAK && ! any_important_kernel_developer_name)?

The few times I've tried to NAK something outright, I've always tried to attach
plenty of technical explanation (usually of the form "Gaak, this oopses my
laptop") :), and cc: the relevant important_name, and hope they listen.

Fortunately, most of the time I can get away with a politely phrased variation of
"important_name would probably appreciate if you fixed XYZ and resubmitted"
comment.. ;)

--==_Exmh_1191766530_10413P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHCOoCcC3lWbTT17ARAvzKAJ9vrNgjbKx2XsLdhG6nJkbTVzpUzQCeKaDV
iygV5JNrjz75gv3lhcNnJLE=
=aNjN
-----END PGP SIGNATURE-----

--==_Exmh_1191766530_10413P--
