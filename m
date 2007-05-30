Return-Path: <linux-kernel-owner+w=401wt.eu-S1762194AbXE3WZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762194AbXE3WZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759006AbXE3WZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:25:32 -0400
Received: from mail.ipom.com ([69.73.131.218]:44516 "EHLO mail.ipom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761696AbXE3WZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:25:29 -0400
Date: Wed, 30 May 2007 15:25:24 -0700
From: Phil Dibowitz <phil@ipom.com>
To: Dave Jones <davej@redhat.com>, Ben Collins <bcollins@ubuntu.com>,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH 6/6] UNUSUAL_DEV: Sync up some reported devices from Ubuntu
Message-ID: <20070530222524.GI3631@ipom.com>
References: <98cd38b5.git.bcollins@ubuntu.com> <317339ef5cb48f652b8eb33c3a1a44d8a2b31493.1179964369.git.bcollins@ubuntu.com> <20070530215028.GD2794@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GBuTPvBEOL0MYPgd"
Content-Disposition: inline
In-Reply-To: <20070530215028.GD2794@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--GBuTPvBEOL0MYPgd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 30, 2007 at 05:50:28PM -0400, Dave Jones wrote:
> On Wed, May 23, 2007 at 06:39:24PM -0400, Ben Collins wrote:
>  > Various unusual dev entries accumulated from Ubuntu bug reports.
>  >=20
>  > CC: Phil Dibowitz <phil@ipom.com>
>  > CC: Alan Stern <stern@rowland.harvard.edu>
>  > CC: linux-usb-devel@lists.sourceforge.net
>  > Signed-off-by: Ben Collins <bcollins@ubuntu.com>
>  > ---
>  >  drivers/usb/storage/unusual_devs.h |   21 +++++++++++++++++++--
>  > =20
>  > +/* Reported by Edward Chapman <[EMAIL PROTECTED]>
>=20
> The "<[EMAIL PROTECTED]>" seems a bit pointless.

Yeah - I already asked for that to get nuked, it was removed before I
accepted the patch, and before Greg pushed it up to Linus.

--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Never write it in C if you can do it in 'awk';
 Never do it in 'awk' if 'sed' can handle it;
 Never use 'sed' when 'tr' can do the job;
 Never invoke 'tr' when 'cat' is sufficient;
 Avoid using 'cat' whenever possible" -- Taylor's Laws of Programming


--GBuTPvBEOL0MYPgd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGXfnUN5XoxaHnMrsRAlc2AKCLg4dsvQKWSsDwRSrc7a/N7kIiSwCgp85Q
c0C0iJrmIslPzPt7LDg9BRw=
=WuOr
-----END PGP SIGNATURE-----

--GBuTPvBEOL0MYPgd--
