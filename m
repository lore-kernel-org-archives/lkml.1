Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbYKQOBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbYKQOBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 09:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYKQOBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 09:01:13 -0500
Received: from zucker.schokokeks.org ([78.46.69.5]:35050 "EHLO
	zucker.schokokeks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbYKQOBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 09:01:13 -0500
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Nov 2008 09:01:13 EST
From: Hanno =?utf-8?q?B=C3=B6ck?= <hanno@hboeck.de>
To: linux-kernel@vger.kernel.org
Subject: Inclusion of tp_smapi module into kernel?
Date: Mon, 17 Nov 2008 14:55:49 +0100
User-Agent: KMail/1.9.10
Cc: tpctl-users@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart76685882.XZN7g1HNW6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811171455.50039.hanno@hboeck.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart76685882.XZN7g1HNW6
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

=46or thinkpad users, there is the tp_smapi module (along with thinkpad_ec =
and=20
an improved hdaps driver):
http://sourceforge.net/projects/tpctl

I wanted to ask if there is some status on possible kernel inclusion. On
http://www.linuxdriverproject.org/twiki/bin/view/Main/OutOfTreeDrivers
I read
"will not be accepted upstream due to authorship issues (written by an=20
anonymous developer)"

Now I can see copyright notices in all source files, though they may be=20
incomplete. But anyway, would this be a real problem?
Is there any rule that kernel code needs a named author? As long as it has =
a=20
fitting license, shouldn't this be fine?

(tp_smapi and thinkpad_ec are gpl2 or later, hdaps is gpl2, so this should =
be=20
just fine)

cu,

=2D-=20
Hanno B=C3=B6ck		Blog:		http://www.hboeck.de/
GPG: 3DBD3B20		Jabber/Mail:	hanno@hboeck.de

http://waldbesetzung.blogsport.de/ Waldbesetzung gegen Flughafenausbau=20
=46rankfurt, 28. - 30.11.
http://www.jukss.de/ Jugemdumweltkongress, 27.12.-4.1.

--nextPart76685882.XZN7g1HNW6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkkhd+YACgkQr2QksT29OyDPoQCgkStFTsQ8k9HUnf2AnRPa11iS
uqQAoJz5mklmivpGgPWxXftWWs2gJWRX
=n9Gh
-----END PGP SIGNATURE-----

--nextPart76685882.XZN7g1HNW6--
