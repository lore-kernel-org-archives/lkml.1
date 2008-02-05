Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbYBELlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbYBELlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 06:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbYBELlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 06:41:37 -0500
Received: from asmodis.mb-net.net ([193.22.253.2]:54575 "EHLO
	asmodis.mb-net.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbYBELlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 06:41:36 -0500
Date: Tue, 5 Feb 2008 12:41:32 +0100
From: Michael Bussmann <bus@mb-net.net>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: OOM killer on idle machine
Message-ID: <20080205114132.GB12009@ruf099.fkie.fgan.de>
References: <20080205100423.GA12009@ruf099.fkie.fgan.de> <20080205110818.GA8333@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
Content-Disposition: inline
In-Reply-To: <20080205110818.GA8333@linux.vnet.ibm.com>
X-message-flag: Please send plain text messages only. Thank you.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On 2008-02-05 16:38:18 +0530, Dhaval Giani wrote:
> Looks like quicklists again. Can you try patching your kernel with the
> following patch. It should be there in the next stable release.

Thanks for your swift response.  I just booted the box with the patched
kernel and I will monitor it for the next weeks.

Cheers,
MB

--=20
Michael Bussmann <bus@mb-net.net>
BOFH excuse #294:
PCMCIA slave driver

--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHqEtsMOF/Y/9ZWXkRAiK2AKCGevz6nQlizDFFzl2TpKfSaL1BowCfXJP8
I0R2yhTKgmdNQ9zSQSLLhnc=
=ATMQ
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--
