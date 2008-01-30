Return-Path: <linux-kernel-owner+w=401wt.eu-S1761339AbYA3Tpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761339AbYA3Tpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbYA3Tpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:45:34 -0500
Received: from hydra.gt.owl.de ([195.71.99.218]:38969 "EHLO hydra.gt.owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757369AbYA3Tpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:45:33 -0500
Date: Wed, 30 Jan 2008 20:42:40 +0100
From: Florian Lohoff <flo@rfc822.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.24] bcm203x bluetooth dongle does not work
Message-ID: <20080130194240.GA2709@paradigm.rfc822.org>
References: <20080130164920.GA15071@paradigm.rfc822.org> <1201714432.6218.101.camel@violet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <1201714432.6218.101.camel@violet>
Organization: rfc822 - pure communication
X-SpiderMe: mh-200801302039@listme.rfc822.org
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 30, 2008 at 06:33:52PM +0100, Marcel Holtmann wrote:
> we moved away from using a timer and using a workqueue now. It wrote the
> patch to use a workqueue and tested that it works. Starting with 2.6.19
> we the usage of a workqueue is default. Can you verify that non of the
> kernels 2.6.19-2.6.23 are working. We might have missed a change inside
> the USB subsystem within the 2.6.24 timeframe.

My tests were on 2.6.24 which does not work as described. Newer
kernels dont boot due to crash in ide-cd so i cant test ...

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHoNMwUaz2rXW+gJcRAk1uAJ0SOpM+LpKczkYZfaDbZh7VhtIV/QCfZvWH
sDu5sHumxQMF/BKOyI9kI2k=
=5ZgO
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
