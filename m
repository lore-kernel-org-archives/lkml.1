Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbZGBIYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbZGBIYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 04:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbZGBIYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 04:24:07 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:40437 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZGBIYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 04:24:04 -0400
Date: Thu, 2 Jul 2009 10:24:04 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Paul Menage <menage@google.com>
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] [RFC] Support named cgroups hierarchies
Message-ID: <20090702082403.GC4305@localdomain>
Reply-To: Louis.Rilling@kerlabs.com
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com> <20090702021057.14469.37548.stgit@menage.mtv.corp.google.com> <20090702080902.GB4305@localdomain> <6599ad830907020119g68abedbeu19ef46f32c4f6f3d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-20703-1246523020-0001-2"
Content-Disposition: inline
In-Reply-To: <6599ad830907020119g68abedbeu19ef46f32c4f6f3d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-20703-1246523020-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 02, 2009 at 01:19:30AM -0700, Paul Menage wrote:
> On Thu, Jul 2, 2009 at 1:09 AM, Louis Rilling<Louis.Rilling@kerlabs.com> =
wrote:
> >
> > I did not see anything preventing two hierarchies from having the same
> > (non empty) name.
>=20
> If you try to mount with a name that matches an already existing
> hierarchy, and you leave the subsystem options empty or give options
> that match the existing mount, then you get the original mount; if you
> specify conflicting options you get an error. I don't think the code
> will let you have two hierarchies with the same non-empty name.

Ah, true. Don't know why I concluded that, even after having read the
relevant portion of the code.
Sorry for the noise.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-20703-1246523020-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpMbqMACgkQVKcRuvQ9Q1RyLwCeMz/zLRvVncgy39FwG10IP41+
H0YAoL0pERUAx9+up+kVC3S5fyHYTf83
=rCwa
-----END PGP SIGNATURE-----

--=_bohort-20703-1246523020-0001-2--
