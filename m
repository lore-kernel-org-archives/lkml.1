Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbZCJSJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbZCJSJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 14:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbZCJSI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 14:08:59 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50072 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbZCJSI6 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 14:08:58 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: porte64@free.fr, linux-kernel@vger.kernel.org
Subject: Re: read-only partitions: does the policy apply to all metadata ?
In-Reply-To: Your message of "Tue, 10 Mar 2009 17:34:37 -0000."
             <20090310173437.2a8114b2@lxorguk.ukuu.org.uk>
From: Valdis.Kletnieks@vt.edu
References: <355270241.1702481236702404399.JavaMail.root@spooler8-g27.priv.proxad.net> <29610.1236705759@turing-police.cc.vt.edu>
            <20090310173437.2a8114b2@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1236708523_3963P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 10 Mar 2009 14:08:43 -0400
Message-ID: <31743.1236708523@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1236708523_3963P
Content-Type: text/plain; charset=us-ascii

On Tue, 10 Mar 2009 17:34:37 -0000, Alan Cox said:

> Replay it to a snapshot backed by the r/o fs ...

Assuming you've got an LVM in place, and someplace to put the snapshot,
and all that.  It's certainly well outside what you'd *expect* to happen
if you do a 'mount -o ro' of an ext3 file system. ;)

--==_Exmh_1236708523_3963P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJtqyrcC3lWbTT17ARAu6fAKCBj1YuqrSc3aWDSGEwrnx0BSo6EwCfSh7X
cLfxX0V3vW8pu40QJi2zXYo=
=/baV
-----END PGP SIGNATURE-----

--==_Exmh_1236708523_3963P--
