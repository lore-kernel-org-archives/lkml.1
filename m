Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbZCTGp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbZCTGp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 02:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbZCTGpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 02:45:10 -0400
Received: from light.bluelinux.co.uk ([195.10.223.138]:54071 "EHLO
	light.bluelinux.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbZCTGpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 02:45:06 -0400
X-Greylist: delayed 1982 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Mar 2009 02:45:06 EDT
Date: Fri, 20 Mar 2009 17:08:23 +1100
From: Daniel Stone <daniel@fooishbar.org>
To: Greg KH <greg@kroah.com>
Cc: Sindhudweep Sarkar <sindhudweep.sarkar@gmail.com>,
       David Airlie <airlied@linux.ie>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core
	changes
Message-ID: <20090320060823.GF32194@fooishbar.org>
Mail-Followup-To: Daniel Stone <daniel@fooishbar.org>,
	Greg KH <greg@kroah.com>,
	Sindhudweep Sarkar <sindhudweep.sarkar@gmail.com>,
	David Airlie <airlied@linux.ie>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	Richard Purdie <rpurdie@linux.intel.com>
References: <20090319040809.GA29249@kroah.com> <6c046ab30903190903r298a0334n939e64403b8aeda6@mail.gmail.com> <20090319162719.GB32078@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n/aVsWSeQ4JHkrmm"
Content-Disposition: inline
In-Reply-To: <20090319162719.GB32078@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n/aVsWSeQ4JHkrmm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Greg,

On Thu, Mar 19, 2009 at 09:27:19AM -0700, Greg KH wrote:
> On Thu, Mar 19, 2009 at 12:03:09PM -0400, Sindhudweep Sarkar wrote:
> > TI-OMAP 3xxx and a couple of other arm processors use similar SGX-5xx
> > graphics cores. IIRC arm is often little endian so perhaps a unified
> > driver would be easier in the long term.
>=20
> Long term lots of things are good.
>=20
> But how do I get my laptop that I currently have right now up and
> running properly with linux in a better-than-800x600-framebuffer mode?
>=20
> That's why I need/want this driver now, there are hundreds of thousands
> of these types of laptops in the pipeline to users and I want them to
> run Linux, not be forced to run some other operating system...

By the same logic, would you support including the proprietary NVIDIA
driver while we wait for Nouveau to catch up?

Cheers,
Daniel

--n/aVsWSeQ4JHkrmm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknDMtcACgkQUVYB1rKAgJSbjACguk+5zlu1aEgS7nDC5L1l2Qbw
U7cAnRWLsbAAgCVw3yrmV462dqLNmJ/i
=2Lno
-----END PGP SIGNATURE-----

--n/aVsWSeQ4JHkrmm--
