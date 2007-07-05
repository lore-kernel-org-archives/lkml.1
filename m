Return-Path: <linux-kernel-owner+w=401wt.eu-S1760180AbXGENk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbXGENk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 09:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758725AbXGENkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 09:40:00 -0400
Received: from saltmine.radix.net ([207.192.128.40]:43276 "EHLO
	saltmine.radix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095AbXGENj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 09:39:59 -0400
X-Greylist: delayed 638 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jul 2007 09:39:59 EDT
Date: Thu, 5 Jul 2007 09:39:47 -0400
From: Thomas Dickey <dickey@radix.net>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070705133947.GB9003@saltmine.radix.net>
References: <8yZun-1bO-5@gated-at.bofh.it> <8CszT-4hd-11@gated-at.bofh.it> <8CtPi-6qj-9@gated-at.bofh.it> <8Cus1-7eL-11@gated-at.bofh.it> <8CwtU-1Z5-3@gated-at.bofh.it> <8Cxgd-3fN-9@gated-at.bofh.it> <8CKQ8-7HN-13@gated-at.bofh.it> <8CKZV-7Ur-11@gated-at.bofh.it> <8CLCt-vX-3@gated-at.bofh.it> <8CM5x-19K-3@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <8CM5x-19K-3@gated-at.bofh.it>
User-Agent: Mutt/1.3.27i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 03, 2007 at 10:40:07AM +0200, Ingo Molnar wrote:
> yeah, i use gnome-terminal exclusively. But testers looking for CFS=20
> regressions do run every shell on the planet :-)

=2E..and people running older kernels get different results (no surprise)

fwiw, I ran 'top' on 5 terminals with xterm-spam running concurrently
on 2.6.15 (rxvt, pterm, xterm, konsole and gnome-terminal).

For that case, gnome-terminal was definitely the slowest,
and used the most CPU time (more than a factor of three slower
than xterm).  konsole was about 2.5, pterm was about the same
as xterm, and rxvt about half the CPU (ymmv).
>=20
> gnome-terminal is also faster all around (at least on my box):

--=20
Thomas E. Dickey
http://invisible-island.net
ftp://invisible-island.net

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (SunOS)
Comment: For info see http://www.gnupg.org

iD8DBQFGjPShtIqByHxlDocRAmWTAJ9245WxFsK8KHTQhW8YGyGzWn1RmwCdEHxV
SRq9GvRDF2uvbdNl+hO+bhw=
=Jx/4
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
