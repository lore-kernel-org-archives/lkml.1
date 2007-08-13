Return-Path: <linux-kernel-owner+w=401wt.eu-S969845AbXHMUGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969845AbXHMUGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760379AbXHMUGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:06:19 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50355 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760047AbXHMUGR (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:06:17 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Satyam Sharma <satyam@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
In-Reply-To: Your message of "Mon, 13 Aug 2007 21:21:10 +0200."
             <Pine.LNX.4.64.0708132120520.30582@fbirervta.pbzchgretzou.qr>
From: Valdis.Kletnieks@vt.edu
References: <1186984174.10249.7.camel@localhost> <200708131933.10125.m.kozlowski@tuxland.pl> <1187026955.2688.4.camel@laptopd505.fenrus.org> <alpine.LFD.0.999.0708132351320.29609@enigma.security.iitk.ac.in>
            <Pine.LNX.4.64.0708132120520.30582@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1187035553_3175P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Aug 2007 16:05:53 -0400
Message-ID: <25564.1187035553@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1187035553_3175P
Content-Type: text/plain; charset=us-ascii

On Mon, 13 Aug 2007 21:21:10 +0200, Jan Engelhardt said:
> 
> On Aug 14 2007 00:02, Satyam Sharma wrote:
> >
> >Better solution is to have multiple MAINTAINERS files distributed in the
> >kernel tree, IMHO -- say a drivers/net/MAINTAINERS for maintainer info on
> >all various net drivers, drivers/kvm/MAINTAINERS for KVM maintainer info,
> >fs/ext3/MAINTAINERS for ext3 maintainers, fs/MAINTAINERS for generic VFS
> >maintainers info, so on and so forth. Of course, these individual
> >MAINTAINERS files could still have the newly-introduced "F:" fields as
> >well (drivers/net/MAINTAINERS would clearly require it, f.e.) ...
> 
> Yes please.
> 
> Or perhaps even putting the maintainer into the Kconfig files?

There's large swaths of code that don't have an obvious Kconfig entry
but do have a Maintainer entry - VFS, lots of kernel/*, and so on.

--==_Exmh_1187035553_3175P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGwLmhcC3lWbTT17ARAi3wAJ4xVndc8WlXvvZE8CfB1BNGcglSZACgpgal
dbTBZl3VIvUlOS/TRCsFD80=
=YmEi
-----END PGP SIGNATURE-----

--==_Exmh_1187035553_3175P--
