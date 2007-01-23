Return-Path: <linux-kernel-owner+w=401wt.eu-S932584AbXAWPe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584AbXAWPe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 10:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbXAWPe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 10:34:28 -0500
Received: from kal-el.real.com ([207.188.23.4]:40801 "EHLO kal-el.real.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbXAWPe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 10:34:27 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jan 2007 10:34:27 EST
Date: Tue, 23 Jan 2007 07:29:44 -0800
From: Larry Walton <lwalton@real.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: SATA exceptions with 2.6.20-rc5
Message-ID: <20070123152944.GA31619@vincent.prognet.com>
References: <fa.ow4pXUncgdZmfLf3oyfrn1W+Bk0@ifi.uio.no> <fa.4QxeKMcmkoyhlL26AivZV6BFQJQ@ifi.uio.no> <45B563C6.5070505@shaw.ca> <200701230134.57775.s0348365@sms.ed.ac.uk> <45B567DF.1050008@shaw.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_kal-el.real.com-809-1169566163-0001-2"
Content-Disposition: inline
In-Reply-To: <45B567DF.1050008@shaw.ca>
X-Operating-System: Linux 2.6.20-rc5 on an i686
Organization: A.M.T. Society
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_kal-el.real.com-809-1169566163-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The last patch (sata_nv-force-int-dev-in-interrupt.patch)=20
seems to have fix the problem.  Much appreciated,=20
thank you. I'd consider it a must have in 2.6.20.


--=20
*--* Mail: lwalton@real.com
*--* Voice: 206.892.6269
*--* Cell: 206.225.0154
*--* HTTP://real.com
--------------------------------------
- - - - - - - R e a l - - - - - - - -


--=_kal-el.real.com-809-1169566163-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFFtinox6zjsLbvibcRAnJrAJ0dHuH+uVW+/vT4QBeuWBUy2tUQ0ACfVTSg
zJolSH5N8tmgnAy4h7aROsI=
=/LzE
-----END PGP SIGNATURE-----

--=_kal-el.real.com-809-1169566163-0001-2--
