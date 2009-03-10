Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbZCJSNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbZCJSNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 14:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbZCJSN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 14:13:29 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:54830 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbZCJSN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 14:13:28 -0400
Subject: Re: [PATCH 00/31] Add a lot of module alias statements
From: Scott James Remnant <scott@canonical.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20090310185558.072e6fc6@hyperion.delvare>
References: <cover.1236702228.git.scott@canonical.com>
	 <20090310184624.4e28d18e@hyperion.delvare> <1236707391.6339.3.camel@quest>
	 <20090310185558.072e6fc6@hyperion.delvare>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vHueMSfZ2VJIVY0loa01"
Date: Tue, 10 Mar 2009 18:13:26 +0000
Message-Id: <1236708806.6339.4.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vHueMSfZ2VJIVY0loa01
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-10 at 18:55 +0100, Jean Delvare wrote:

> On Tue, 10 Mar 2009 17:49:51 +0000, Scott James Remnant wrote:
> > On Tue, 2009-03-10 at 18:46 +0100, Jean Delvare wrote:
> >=20
> > > I don't get how it could make any difference in terms of performance.
> > > As far as I know, all the module aliases that come from the kernel ar=
e
> > > assembled into /lib/modules/$version/modules.alias when the kernel is
> > > installed, and that file must be processed by modprobe the exact same
> > > way another configuration file would. Or am I missing something?
> >
> > With current modprobe those files are turned into a binary index that
> > can be read and processed *much* faster.
>=20
> What would prevent the same binary index from being generated from
> user-provided module aliases?
>=20
Why go to all that effort when adding the alias to the kernel is just a
one-line change, and then it shows up along with all of the other
aliases that depmod generates the existing binary index from?

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-vHueMSfZ2VJIVY0loa01
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm2rcYACgkQSnQiFMl4yK5J6ACdGCmJk8iJxV/6kr19K/NHlVUk
/wYAn1BVfNEQF8S+i3Ifq11Ihk7BUpjC
=lksT
-----END PGP SIGNATURE-----

--=-vHueMSfZ2VJIVY0loa01--

