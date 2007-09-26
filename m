Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbXIZUc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbXIZUc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbXIZUcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:32:19 -0400
Received: from rhineheart.priorweb.be ([213.193.229.215]:40901 "HELO
	rhineheart.priorweb.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751183AbXIZUcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:32:18 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Sep 2007 16:32:17 EDT
Date: Wed, 26 Sep 2007 22:25:29 +0200
From: Kristof Provost <Kristof@provost-engineering.be>
To: mahamuni ashish <ash_lkp@yahoo.co.in>
Cc: linux-kernel@vger.kernel.org
Subject: Re: No linux/module.h
Message-ID: <20070926202529.GB25724@luggage>
References: <120377.13385.qm@web7807.mail.in.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <120377.13385.qm@web7807.mail.in.yahoo.com>
X-PGP-Fingerprint: 6B6E 5EED 8ECF FAE7 1F61  7458 5046 7D0E 11B0 0EE8
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Spam-Scanned: 2.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2007-09-26 11:29:33 (+0100), mahamuni ashish <ash_lkp@yahoo.co.in> wrote:
> I am writing simple kernel module.
> I have included linux/module.h
> compiler gives me error that no such file, I also
> searched it on my machine.
> It really doesn't exist. I am using fedora 6.
> How do I install required libraries.
I suspect you either have an incorrect makefile or you don't have the
kernel source code on your system. The header file can be found in the
kerel source: include/linux/module.h

Regards,=20
Kristof=20

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG+sA5UEZ9DhGwDugRAmSOAJ9dd/bl96u/LDdYOI5IdzCf9vMZXwCfd70g
e/RyqjiZ9k/zZvHxPT/DB6Q=
=JDAs
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
