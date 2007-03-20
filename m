Return-Path: <linux-kernel-owner+w=401wt.eu-S934050AbXCTUEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050AbXCTUEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:04:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934051AbXCTUEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:04:10 -0400
Received: from master.altlinux.org ([62.118.250.235]:3652 "EHLO
	master.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934050AbXCTUEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:04:08 -0400
Date: Tue, 20 Mar 2007 23:03:45 +0300
From: Sergey Vlasov <vsu@altlinux.ru>
To: Jon Masters <jcm@redhat.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, mit-devel@lists.printk.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Subject: Re: [mit-devel] Re: module-init-tools-3.3-pre10 available
Message-ID: <20070320200345.GB4021@procyon.home>
References: <45DD0031.9010808@redhat.com> <20070222170732.22c1320b.vsu@altlinux.ru> <45DDAE24.6080905@redhat.com> <20070223120136.12ea11db@home.brethil> <45DF0B42.2080208@redhat.com> <Pine.LNX.4.61.0702241625030.16527@yvahk01.tjqt.qr> <45E06439.40403@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline
In-Reply-To: <45E06439.40403@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 24, 2007 at 11:13:45AM -0500, Jon Masters wrote:
> Jan Engelhardt wrote:
>=20
> >Out of the box perhaps if it is the .tar.bz2 archive, but the same does =
not
> >always hold for CVS repos, much less SVNs [random guess on svn]. He who=
=20
> >pulls
> >from a developer tree mostly knows to run 'autogen.sh' or 'autoreconf -f=
i'
> >beforehand.
>=20
> You know what, you're right of course. Ok, I'm taking those back *out*=20
> of the repo in the next update and then will have a script generate=20
> these for the tarball. That does sound like the right thing.

Has a final decision about generated files been made?  I don't see any
updates in the git repo, and man pages are still broken (any attempt
to regenerate them will cause changes to the generated files to be
lost).

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGAD4hW82GfkQfsqIRAulrAJwO5ZEKwvqR6jdYPnZM4wwXMW0tsQCfcTpz
p+cL3+siGkt/9suZ12ZGQkk=
=iJx7
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
