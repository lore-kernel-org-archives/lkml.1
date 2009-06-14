Return-Path: <linux-kernel-owner+w=401wt.eu-S1762892AbZFNVqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892AbZFNVqR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 17:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757560AbZFNVqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 17:46:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38889 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbZFNVqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 17:46:03 -0400
Date: Sun, 14 Jun 2009 23:46:03 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, devicetree-discuss@ozlabs.org,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 2/2] uio: add an of_genirq driver
Message-ID: <20090614214603.GA24323@pengutronix.de>
References: <1244765062-14144-1-git-send-email-w.sang@pengutronix.de> <1244765062-14144-3-git-send-email-w.sang@pengutronix.de> <20090614122136.GD3639@local> <20090614171406.GA1010@pengutronix.de> <20090614183357.GE3639@local> <20090614190533.GA7387@pengutronix.de> <20090614192707.GA11003@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20090614192707.GA11003@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 14, 2009 at 12:27:07PM -0700, Greg KH wrote:
> On Sun, Jun 14, 2009 at 09:05:33PM +0200, Wolfram Sang wrote:
> > Well, I assume that issues regarding checkpatch do not have the highest
> > priority (especially while the merge-window is open), which is understa=
ndable.
>=20
> Hm, the "merge-window" for new stuff like these patches is pretty much
> already closed, as you didn't send them _before_ the merge window opened
> up.  You need to get them to us sooner, so we can test stuff out in the
> -next tree for a while before we can merge them.

Seems you got me wrong here :)

As I stated in the introduction ("PATCH [0/2]"), this patch series is _not_
meant for the current merge-window. I just happened to be done with it now.

With the above sentence I just wanted to give a hint, why there was not a r=
eply
to my checkpatch-mail (as Hans seemed to be concerned about that there was
none).

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko1b5sACgkQD27XaX1/VRuqTgCcDl737+mbnMLDUbfJehUaRXeR
rOMAn0rMkD4TsDyT8vcs+jx95DnP7yx9
=jvq6
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
