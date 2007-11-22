Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbXKVKD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbXKVKD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 05:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbXKVKDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 05:03:18 -0500
Received: from partizan.velesys.com ([213.184.230.195]:57337 "EHLO
	partizan.velesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbXKVKDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 05:03:17 -0500
Date: Thu, 22 Nov 2007 12:04:27 +0200
From: "Kirill A. Shutemov" <k.shutemov@velesys.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-acpi@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc3-mm1 - Kernel Panic on IO-APIC
Message-ID: <20071122100427.GB7085@localhost.localdomain>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <4743CC0B.9000508@linux.vnet.ibm.com> <20071120221839.faab108e.akpm@linux-foundation.org> <4743F8D2.2090302@linux.vnet.ibm.com> <20071121012918.eff93b22.akpm@linux-foundation.org> <64bb37e0711211133g355a808dl7c2bec7fe3789ddd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
Content-Disposition: inline
In-Reply-To: <64bb37e0711211133g355a808dl7c2bec7fe3789ddd@mail.gmail.com>
X-Operating-System: ALT Linux Sisyphus (20070101) (Kernel 2.6.24-kas-alt1)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On [Wed, 21.11.2007 20:33], Torsten Kaiser wrote:
> On Nov 21, 2007 10:29 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 21 Nov 2007 14:52:26 +0530 Kamalesh Babulal <kamalesh@linux.vne=
t.ibm.com> wrote:
> >
> > > Andrew Morton wrote:
> > > > On Wed, 21 Nov 2007 11:41:23 +0530 Kamalesh Babulal <kamalesh@linux=
=2Evnet.ibm.com> wrote:
> > > >> ACPI: Core revision 20070126
> > > >> ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> > > >> Kernel panic - not syncing: IO-APIC + timer doesn't work! Try usin=
g the 'noapic' kernel parameter
>=20
> I seen an identical error.

This bug is also reproducible with qemu.

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + Velesys LLC, http://www.velesys.com/
 + ALT Linux Team, http://www.altlinux.com/

--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHRVQrbWYnhzC5v6oRAjiGAJ9mFEvEEpaCJlaujVRljQs8npd8jACeOynx
4XJPQveZ6Pl77c/LHODAhgE=
=oqid
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--
