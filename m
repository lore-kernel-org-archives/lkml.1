Return-Path: <linux-kernel-owner+w=401wt.eu-S1759884AbYFDUFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884AbYFDUFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 16:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbYFDUFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 16:05:34 -0400
Received: from lug-owl.de ([195.71.106.12]:50837 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbYFDUFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 16:05:33 -0400
X-Greylist: delayed 1720 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jun 2008 16:05:33 EDT
Date: Wed, 4 Jun 2008 21:36:51 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Rainer Koenig <Rainer.Koenig@fujitsu-siemens.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Who can backport the AHCI driver to older kernels
Message-ID: <20080604193651.GU19431@lug-owl.de>
Mail-Followup-To: Rainer Koenig <Rainer.Koenig@fujitsu-siemens.com>,
	Mikael Pettersson <mikpe@it.uu.se>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806031247.42046.Rainer.Koenig@fujitsu-siemens.com> <200806031352.31940.elendil@planet.nl> <18501.13296.224958.291840@harpo.it.uu.se> <200806040650.12683.Rainer.Koenig@fujitsu-siemens.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RDZKVD6KUognMRfE"
Content-Disposition: inline
In-Reply-To: <200806040650.12683.Rainer.Koenig@fujitsu-siemens.com>
X-Operating-System: Linux mail 2.6.18-5-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RDZKVD6KUognMRfE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-06-04 06:50:12 +0200, Rainer Koenig <Rainer.Koenig@fujitsu-sie=
mens.com> wrote:
> Am Dienstag, 3. Juni 2008 14:07 schrieb Mikael Pettersson:
> > Redhat seems to regularly backport the entire libata layer
> > to at least 2.6.18 (RHEL5) and maybe also 2.6.9 (RHEL4).
>=20
> Yes indeed we get perfect support from both Red Hat and SUSE for their=20
> enterprise level distribution. I already got a driver kit for the=20
> SLES10 kernel. The problem is that the targeted market is not willing
> to use enterprise level (which means spend money for subscription)=20
> distros. They go for the "free" (as in free beer) distros and suffer=20
> from missing drivers.=20

Erm... Maybe you'd install a newer version of eg. Debian. At least
here, I have:

jbglaw@jblaptop:~$ uname -a
Linux jblaptop 2.6.25-2-686 #1 SMP Tue May 27 15:38:35 UTC 2008 i686 GNU/Li=
nux
jbglaw@jblaptop:~$

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
 Signature of:                    Don't believe in miracles: Rely on them!
 the second  :

--RDZKVD6KUognMRfE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIRu7THb1edYOZ4bsRApbNAJ9W5s1hlOSsDQO5DMbPepe6+ImM9QCcCcvB
ipvT2bhS3OxE7lJ+OoFA1nw=
=tQbn
-----END PGP SIGNATURE-----

--RDZKVD6KUognMRfE--
