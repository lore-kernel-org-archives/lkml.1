Return-Path: <linux-kernel-owner+w=401wt.eu-S1760272AbXIOHLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272AbXIOHLy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 03:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbXIOHLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 03:11:46 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:60524 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038AbXIOHLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 03:11:45 -0400
From: Prakash Punnoor <prakash@punnoor.de>
To: Jon Ivar Rykkelid <jonry@pvv.org>
Subject: Re: sata_nv issues with MCP51 SATA controller
Date: Sat, 15 Sep 2007 09:12:28 +0200
User-Agent: KMail/1.9.7
Cc: Robert Hancock <hancockr@shaw.ca>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
References: <46E8EABF.3060409@pvv.org> <46EA97F0.9000300@pvv.org> <46EAF099.9070805@pvv.org>
In-Reply-To: <46EAF099.9070805@pvv.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4496046.INa2oGmIMX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200709150912.28358.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4496046.INa2oGmIMX
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On the day of Friday 14 September 2007 Jon Ivar Rykkelid hast written:
> Hi, I'm getting inmore confident that the driver is the issue.
>
>
> (Or have anyone EVER been successful with the latest kernel/driver on
> this HW)?

I don't have exaclty the same hw, but the same chipset and I don't have any=
=20
problems - even with the swncq patch applied. Do you have an hpet? If not,=
=20
try booting with acpi_use_time_override. My system won't work with skipping=
=20
the override.

=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart4496046.INa2oGmIMX
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBG64XcxU2n/+9+t5gRAszKAKCnhayrG2I/H0lCgD+gXx9auiIuKwCgmfd1
oHrcTXYb8G2k78izW1PwAHY=
=pBJY
-----END PGP SIGNATURE-----

--nextPart4496046.INa2oGmIMX--
