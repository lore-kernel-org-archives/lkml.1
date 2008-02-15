Return-Path: <linux-kernel-owner+w=401wt.eu-S933409AbYBOO6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409AbYBOO6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 09:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758665AbYBOO6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 09:58:04 -0500
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:52093 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757810AbYBOO6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 09:58:02 -0500
From: Prakash Punnoor <prakash@punnoor.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Disk schedulers
Date: Fri, 15 Feb 2008 15:57:54 +0100
User-Agent: KMail/1.9.7
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>, linux-kernel@vger.kernel.org
References: <20080214162104.GA5347@ics.muni.cz> <Pine.LNX.4.64.0802151541370.30301@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0802151541370.30301@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1373559.hoEbklHTSK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802151557.59082.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1373559.hoEbklHTSK
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On the day of Friday 15 February 2008 Jan Engelhardt hast written:
> On Feb 14 2008 17:21, Lukas Hejtmanek wrote:
> >Hello,
> >
> >whom should I blame about disk schedulers?
>
> Also consider
> - DMA (e.g. only UDMA2 selected)
> - aging disk

Nope, I also reported this problem _years_ ago, but till now much hasn't=20
changed. Large writes lead to read starvation.

=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart1373559.hoEbklHTSK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHtah3xU2n/+9+t5gRAhVBAKCLdbLHMUfg3IYXmsxewjsKdDWfwACdHD7P
AQatuU5y7UGh5pxQhST7scc=
=oTa4
-----END PGP SIGNATURE-----

--nextPart1373559.hoEbklHTSK--
