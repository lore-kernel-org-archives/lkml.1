Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbZLIF2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbZLIF2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 00:28:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZLIF21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 00:28:27 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59275 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbZLIF20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 00:28:26 -0500
Date: Wed, 9 Dec 2009 16:28:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Jiri Kosina <jkosina@suse.cz>
Subject: linux-next: manual merge of the tty tree with the trivial tree
Message-Id: <20091209162826.a28c6c68.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__9_Dec_2009_16_28_26_+1100__k/li5H_iCbfE4Aw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Dec_2009_16_28_26_+1100__k/li5H_iCbfE4Aw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in drivers/mmc/card=
/sdio_uart.c between commit 1e04b7ae709d19d5c9f69c64e1e30253018ce102 ("sdio=
_uart: coding style fixes") from the trivial tree and various commits from =
the tty tree.

I just used the tty tree version where they clashed.  Jiri, you might
consider sending that patch to Greg for the tty tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__9_Dec_2009_16_28_26_+1100__k/li5H_iCbfE4Aw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksfNXoACgkQjjKRsyhoI8zVKgCgtKksQ5+onFt2aguUnhjpdqpq
qrEAnimgpwSS5AUAEGyyDyyePaG6tODq
=XjsJ
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Dec_2009_16_28_26_+1100__k/li5H_iCbfE4Aw--
