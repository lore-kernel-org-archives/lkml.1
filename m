Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbZAZLwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbZAZLwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 06:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZAZLvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 06:51:55 -0500
Received: from bohort.kerlabs.com ([62.160.40.57]:53398 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbZAZLvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 06:51:55 -0500
Date: Mon, 26 Jan 2009 12:51:52 +0100
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
Subject: Re: Make lockdep happy with configfs
Message-ID: <20090126115151.GC7532@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
Mail-Followup-To: Joel Becker <Joel.Becker@oracle.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	cluster-devel@redhat.com, swhiteho@redhat.com, peterz@infradead.org
References: <20081218111536.GR19128@hawkmoon.kerlabs.com> <1229623218-8056-1-git-send-email-louis.rilling@kerlabs.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-7051-1232970550-0001-2"
Content-Disposition: inline
In-Reply-To: <1229623218-8056-1-git-send-email-louis.rilling@kerlabs.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-7051-1232970550-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18/12/08 19:00 +0100, Louis Rilling wrote:
>=20
> Hi,
>=20
> Here is a patchset implementing a more lockdep-friendly solution to make =
lockdep
> happy with configfs.
>=20
> The first patch could probably be cleaner, but first let's see if the
> approach is ok.
> I don't have a good setup to test the second patch beyond compilation, bu=
t I
> guess that Joel has one :)
>=20
> So, does it look better?

Joel,

Are you going to take one of these approaches to make lockdep and configfs
cohabit?

Thanks,

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-7051-1232970550-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJfaPXVKcRuvQ9Q1QRAk+uAJ93tlavszU+VNg1HUbGtw3bKYqluQCfbfGF
M94fUkHNdWVT98s0j5XPy9E=
=J5Yx
-----END PGP SIGNATURE-----

--=_bohort-7051-1232970550-0001-2--
