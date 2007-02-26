Return-Path: <linux-kernel-owner+w=401wt.eu-S932284AbXBZGsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbXBZGsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 01:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933778AbXBZGsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 01:48:33 -0500
Received: from iucha.net ([209.98.146.184]:33878 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932284AbXBZGsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 01:48:32 -0500
Date: Mon, 26 Feb 2007 00:48:32 -0600
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Correction 2.6.21-rc1 Was: 2.6.20-rc1: CIFS cheers, NFS4 jeers
Message-ID: <20070226064832.GA29073@iucha.net>
References: <20070226064500.GZ29073@iucha.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aDj5WtVma0yWCzS8"
Content-Disposition: inline
In-Reply-To: <20070226064500.GZ29073@iucha.net>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--aDj5WtVma0yWCzS8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 26, 2007 at 12:45:00AM -0600, Florin wrote:
> After the writing stalls, I have echoed 't' into /proc/sysrq-trigger
> and got a trace, which is at http://iucha.net/20-rc1/after.1.  There was
> no oops before the trace request; the 'before' dmesg is at
> http://iucha.net/20-rc1/before.1 .

The kernel on the client is 2.6.21-rc1 (but it echoes problems I
reported in December with 2.6.20 series as well) as can be seen from
the kernel logs.

I have corrected the links:

   http://iucha.net/21-rc1/before.1
   http://iucha.net/21-rc1/after.1
   http://iucha.net/21-rc1/config-2.6.21-rc1

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--aDj5WtVma0yWCzS8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF4oLAND0rFCN2b1sRAtW3AJ40cK+vuVv4bIahZJKFL9CdLTORXQCfTaAf
r7+7HQ+aZg3gsopDReenBx8=
=qFAA
-----END PGP SIGNATURE-----

--aDj5WtVma0yWCzS8--
