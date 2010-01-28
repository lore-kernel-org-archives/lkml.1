Return-Path: <linux-kernel-owner+w=401wt.eu-S932191Ab0A1FFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab0A1FFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 00:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932175Ab0A1FFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 00:05:06 -0500
Received: from nn7.de ([85.214.94.156]:38228 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab0A1FFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 00:05:05 -0500
Subject: Re: [Bug #15043] Display goes off with i915.powersave=1
From: Soeren Sonnenburg <sonne@debian.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J\. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <20100127095734.6c1afc10@jbarnes-piketon>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
	 <hE3x9c-4KZM.A.XwF.VKMXLB@chimera>
	 <20100127095734.6c1afc10@jbarnes-piketon>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-06Z3WBMibBtWAC/P+IAh"
Date: Thu, 28 Jan 2010 06:05:00 +0100
Message-ID: <1264655100.9187.233.camel@no>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-06Z3WBMibBtWAC/P+IAh
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-01-27 at 09:57 -0800, Jesse Barnes wrote:
> On Sun, 24 Jan 2010 23:04:37 +0100 (CET)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>=20
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >=20
> > The following bug entry is on the current list of known regressions
> > from 2.6.32.  Please verify if it still should be listed and let me kno=
w
> > (either way).
> >=20
> >=20
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D15043
> > Subject		: Display goes off with i915.powersave=3D1
> > Submitter	: Soeren Sonnenburg <sonne@debian.org>
> > Date		: 2010-01-10 20:09 (15 days old)
> > References	: http://marc.info/?l=3Dlinux-kernel&m=3D126315457519505&w=
=3D4
>=20
> If this isn't fixed yet, I hope David's patch fixes it.  See "[Bug
> #14897] i915: Commit 0e442c60 causes flickering".

that sounds indeed like it, because sometimes I observe a flickering
before darkness :) I will give the new kernel a try though I don't have
time to do it in the next few days :/

Soeren
--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-06Z3WBMibBtWAC/P+IAh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJLYRr8AAoJEH82z1Wqh6p3+zEP/jmn4z9yicFNqF68ijTZ2/4N
cHLMRowtis92SccP6P7aMya75ACWuON0h2ViskhnbEE5HTDoADbNyOjQ6+0gB2bk
jYC1/hS71R5fNmlZSJL58y8TsPAb3Pe09h8+S3zcA+/SEipUfnKva23gYNumZcr+
RINFyqBUu4W64aGU4HLOt6iKrMeGrN62jst6G0lADNH0SgsF6TvSJ3UQCI70qono
zLkMqnPXWyTQmnwoZobdWMiMXs8zLJcNEE6dodNBy9uUD+vFrgK9kNMYk//V5hdp
UZjuUnAZ+NcgOJqx4c69PZBcBRhq++i+IQ5q/V2B4kaggXP4bjEkFyu45APO1HKF
PyZrH8j9znrCWfR5zNTGC5TICZduiwN929wyjcq1wcAATFNJ26Kq2NHiB4GKAGcW
oCLEKRzGQ0DJv0oKxiEKsPy7EgUzkB1HqYszCtZweamaYJrbvPjYjABYkEpc9QF9
/VgHLjqRQSR5erWEVJdJeTV3Zowlse+DNx8oK1GPqtBfMXX6MFV18X/caO83eOSl
6KK2m0mh1gGyT9fTo5igMx0/guGKuzZuE5byK9uRvVEhn+/7vIAs5Y6QmT8MmhTb
KEgv7PByDbh55bpU/jJgn6ZdTXLp9RuK7ZAWW5OPAInjMLMSenTlVxur6sCVn8Tv
MsjwEDyHLRUMmVVQ7Vhz
=KKsd
-----END PGP SIGNATURE-----

--=-06Z3WBMibBtWAC/P+IAh--
