Return-Path: <linux-kernel-owner+w=401wt.eu-S1762043AbXJYPRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762043AbXJYPRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 11:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760681AbXJYPRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 11:17:38 -0400
Received: from lnx130.hrz.tu-darmstadt.de ([130.83.174.24]:35634 "EHLO
	lnx130.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754298AbXJYPRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 11:17:37 -0400
Date: Thu, 25 Oct 2007 17:13:10 +0200
From: Volker Sauer <vsauer@dvs.tu-darmstadt.de>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: linux-kernel@vger.kernel.org, adi@postpi.com,
       Jesse Huang <jesse@icplus.com.tw>, netdev@vger.kernel.org
Subject: Re: D-Link DFE-580TX and snmpd problems, who's maintainer of
	sundance.c ?
Message-ID: <20071025151310.GA14155@volker-sauer.de>
References: <20071024171129.GA14255@volker-sauer.de> <20071024214650.GA6253@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <20071024214650.GA6253@electric-eye.fr.zoreil.com>
X-Mailer: Mutt http://www.mutt.org/
X-Editor: Vim http://www.vim.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
X-TUD-HRZ-MailScanner: Found to be clean
X-TUD-HRZ-MailScanner-SpamCheck: 
X-MailScanner-From: vsauer@dvs.tu-darmstadt.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mi, 24 Okt 2007, Francois Romieu <romieu@fr.zoreil.com> wrote:
> > So the questions is: why? What is this good for?
> > And: can I remove it? I can not abandon snmpd and the messages spam my
> > syslog.
> > Or: do I have to patch snmpd?
>=20
> Please try the attached patch.
>=20

Hi Francois,

the patch solves the problem. Thank you.

Regards
Volker

--=20
  Volker Sauer  *  Poststrasse 1/601   *   64293 Darmstadt  *   Germany
  E-Mail/Jabber: volker(at)volker-sauer.de * http://www.volker-sauer.de
  PGPKey-Fingerprint: DB26 11C7 B12E 0B27 3999 2E4F 7E35 4E4D 5DD5 D0E0
  http://wwwkeys.de.pgp.net/pks/lookup?op=3Dget&search=3D0x7E354E4D5DD5D0E0=
=20

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHILKGfjVOTV3V0OARAqsnAKCzSfhhhuwxVaiSrSYy9OIuYVxhugCg6c70
ipliGU2zczdI/CFe9uIcsao=
=6E+Y
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
