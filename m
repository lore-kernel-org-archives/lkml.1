Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbZCYLJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbZCYLJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbZCYLJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:09:36 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:51863 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbZCYLJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:09:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=wOHvLKuaUm2a39xxqWX4skYM1f+2SYIBYUAATNj1a5OxptMRspZ83U8PRkHT1Znzin
         bA48aajn9ebHBB73Hu7WkHlbWlmcCS46+R3JnFbmKl2OYcrdAmmMKVD9YGzpIQ/2RwC1
         whRcYO9RU5InqH1RO5TZvz4U20WRBM84pxK8c=
From: Evgeniy Ivanov <lolkaantimat@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Linux and FPU
Date: Wed, 25 Mar 2009 14:09:13 +0300
User-Agent: KMail/1.11.1 (Linux/2.6.27.19-3.2-pae; KDE/4.2.1; i686; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1519788.PJv9G2UCZz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200903251409.27827.lolkaantimat@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1519788.PJv9G2UCZz
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

Can somebody point me to some general places, where I can look on how FPU=20
support is implemented. I understand that there is not one place, where thi=
ngs=20
done, the only I know, that there should be places for detecting FPU hardwa=
re=20
and places with assembly routines for pushing around floating point registe=
rs,=20
assembly/C-hybrid code for handling floating point exceptions.
I'm interesting mostly in x86 (386) things, not other architectures.

If you know some good docs, please point me to them.

P.S. Sorry if it's a wrong list to ask such questions.


=2D-=20
Best regards, Evgeniy.
Key Fingerprint: F316B5A1F6D2054FCD18B74A95400ABB1FE567A3


--nextPart1519788.PJv9G2UCZz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAknKEOcACgkQlUAKux/lZ6O+AwCg0NWuJz2sAtpbqw3t2PNWL7Zk
llMAn1xC7w1jsIxj2wT0RsMIZfRZaa5e
=kTmY
-----END PGP SIGNATURE-----

--nextPart1519788.PJv9G2UCZz--
