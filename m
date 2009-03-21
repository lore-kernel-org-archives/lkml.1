Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbZCUAJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbZCUAJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 20:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbZCUAJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 20:09:27 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:52650 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZCUAJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 20:09:26 -0400
Subject: Re: [patch 38/43] drm/i915: set vblank enabled flag correctly
 across IRQ install/uninstall
From: Eric Anholt <eric@anholt.net>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>
In-Reply-To: <20090320222928.879548230@mini.kroah.org>
References: <20090320222810.386844059@mini.kroah.org>
	 <20090320222928.879548230@mini.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JoudBl2eNIzNeLfok+WW"
Date: Fri, 20 Mar 2009 17:09:22 -0700
Message-Id: <1237594162.4892.24.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JoudBl2eNIzNeLfok+WW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-20 at 15:28 -0700, Greg KH wrote:
> plain text document attachment
> (drm-i915-set-vblank-enabled-flag-correctly-across-irq-install-uninstall.=
patch)
> 2.6.28-stable review patch.  If anyone has any objections, please let us =
know.

I think we're good to go on the DRM series.

<anholt> jbarnes: any concerns about the vblank patches that just got
queued to 2.6.28?
<jbarnes> no, though there's still one regression open against aiglx vt
switch
<anholt> ok, but it's a regression before those queued patches?
<jbarnes> yeah I think so

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-JoudBl2eNIzNeLfok+WW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknEMDEACgkQHUdvYGzw6ve+2QCfb1tWBpMnOHShz5LjCA7yDRDN
FL8An2cuM4YPn3MEWJJD4b4rQbd4tJJn
=6LRp
-----END PGP SIGNATURE-----

--=-JoudBl2eNIzNeLfok+WW--
