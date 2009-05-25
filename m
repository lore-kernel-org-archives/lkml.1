Return-Path: <linux-kernel-owner+w=401wt.eu-S1752961AbZEYS5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbZEYS5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 14:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbZEYS5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 14:57:24 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:53790
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751453AbZEYS5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 14:57:23 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 May 2009 14:57:23 EDT
Date: Mon, 25 May 2009 11:48:31 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@users.sf.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: Question on the removable flag of USB devices
Message-ID: <20090525184831.GT28077@one-eyed-alien.net>
Mail-Followup-To: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@users.sf.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <20090525164553.GA5572@ime.usp.br>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mpb+VUhBqKoEsre9"
Content-Disposition: inline
In-Reply-To: <20090525164553.GA5572@ime.usp.br>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2009 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Mon, 25 May 2009 11:48:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mpb+VUhBqKoEsre9
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 25, 2009 at 01:45:54PM -0300, Rog=E9rio Brito wrote:
> The question is: how are devices determined to be removable or not?
> Sorry if this question is too naive.

It's a bit that the device reports.  The usb-storage driver passes this bit
to the SCSI layer.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

NYET! The evil stops here!
					-- Pitr
User Friendly, 6/22/1998

--mpb+VUhBqKoEsre9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFKGuf/HL9iwnUZqnkRAodCAJ4tvzheJV/b38Y3fYcGf0F6crWFOgCdFGkr
6j3C4+Ntn6fFibjatjU+lJ8=
=gbqL
-----END PGP SIGNATURE-----

--mpb+VUhBqKoEsre9--
