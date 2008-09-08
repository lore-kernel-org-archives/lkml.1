Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbYIHPw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbYIHPw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbYIHPwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:52:17 -0400
Received: from ganymede.vroon.org ([195.66.242.11]:58619 "EHLO
	ganymede.vroon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbYIHPwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:52:17 -0400
Subject: Re: Request for MCE decode (AMD Barcelona, fam 10h)
From: Tony Vroon <tony@vroon.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080908140417.GJ26079@one.firstfloor.org>
References: <1220754742.8530.12.camel@localhost>
	 <87abeivrdf.fsf@basil.nowhere.org> <1220876559.27320.2.camel@localhost>
	 <20080908140417.GJ26079@one.firstfloor.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rqgHEN5+eJ5iL6wWLsxR"
Date: Mon, 08 Sep 2008 16:52:18 +0100
Message-Id: <1220889138.27320.53.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rqgHEN5+eJ5iL6wWLsxR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-08 at 16:04 +0200, Andi Kleen wrote:
> Ok so you wanted linux-kernel to diagnose your hardware for you?

I was hoping for some help in narrowing it down, yes. Jeroen's reply was
very helpful, and more among the line of what I was expecting. I have
contacted all vendors involved now, and it looks like the system RAM is
not fully compatible with the mainboard.

With regard to the message, I would suggest an alternate wording like
such:

A hardware component in your system is failing.
Please contact your hardware vendor(s).
If unsure, contact your CPU vendor first.

Regards,
Tony V.

--=-rqgHEN5+eJ5iL6wWLsxR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkjFSjIACgkQp5vW4rUFj5oEqQCgl48QoATUT2bIEzoY9JjAoUc8
oJ4An3jeW9x1H9M+KyQktqIkEAevA2C9
=Z53z
-----END PGP SIGNATURE-----

--=-rqgHEN5+eJ5iL6wWLsxR--

