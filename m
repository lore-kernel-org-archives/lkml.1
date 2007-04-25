Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbXDYQ0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbXDYQ0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 12:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbXDYQ0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 12:26:20 -0400
Received: from lug-owl.de ([195.71.106.12]:38963 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbXDYQ0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 12:26:19 -0400
Date: Wed, 25 Apr 2007 16:27:06 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: "Shan, Guo Wen (Gavin)" <gshan@alcatel-lucent.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: about linux console and printk
Message-ID: <20070425142706.GR25077@lug-owl.de>
Mail-Followup-To: "Shan, Guo Wen (Gavin)" <gshan@alcatel-lucent.com>,
	linux-kernel@vger.kernel.org
References: <2AC135F730C4A045BAE4F1C1CB83FD4B03EF6B90@exch03.qd.lucent.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bi+HF1AHjw0mn3zx"
Content-Disposition: inline
In-Reply-To: <2AC135F730C4A045BAE4F1C1CB83FD4B03EF6B90@exch03.qd.lucent.com>
X-Operating-System: Linux mail 2.6.18-4-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Bi+HF1AHjw0mn3zx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-04-25 22:22:22 +0800, Shan, Guo Wen (Gavin) <gshan@alcatel-luc=
ent.com> wrote:
> The linux could support several console driver at same time? If so,
> what I need to do is call register_console() for several times?

Did you try that? Have you read through the register_console() code as
well as printk() and how it actually outputs its output?

MfG, JBG
PS: netdev no longer Cc'ed. It's not a networking topic.

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:            http://www.chiark.greenend.org.uk/~sgtatham/bugs.h=
tml
the second  :

--Bi+HF1AHjw0mn3zx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGL2U6Hb1edYOZ4bsRArttAJ9p3AI78KjojRuzbgG1vJhPMbcZwQCfSVA2
xoH3sstOUmkQZHwEWyHMJaQ=
=nnxS
-----END PGP SIGNATURE-----

--Bi+HF1AHjw0mn3zx--
