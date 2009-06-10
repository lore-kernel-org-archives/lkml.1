Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbZFJIl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbZFJIl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 04:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZFJIlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 04:41:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34680 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbZFJIlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 04:41:18 -0400
Date: Wed, 10 Jun 2009 18:41:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Elina Pasheva <epasheva@sierrawireless.com>
Subject: linux-next: manual merge of the usb tree with the ttydev tree
Message-Id: <20090610184114.fe8a849e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Jun_2009_18_41_14_+1000_Di03I3.4Xi14EAL5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Jun_2009_18_41_14_+1000_Di03I3.4Xi14EAL5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg, Alan,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/serial/sierra.c between commit
968b6bc702be2b0953212f1ca56b1dc889c1c72d ("tty-usb-sierra-add-urb-funcs")
from the ttydev tree and various commits from the usb tree.

There is some overlap between the ttydev patch and the usb patches.  I
have just used the version of this file from USB tree (since it seems
that there are many more changes there).

Please sort this out ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Jun_2009_18_41_14_+1000_Di03I3.4Xi14EAL5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkovcaoACgkQjjKRsyhoI8xPAACZAVGy9DcQnAWeKmNFrfUEbmfZ
YvgAninkosSDOFTsVlpFTXbZa2LQFqa/
=d7E+
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Jun_2009_18_41_14_+1000_Di03I3.4Xi14EAL5--
