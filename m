Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbZE2B4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbZE2B4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 21:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbZE2B4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 21:56:44 -0400
Received: from light.bluelinux.co.uk ([195.10.223.138]:49737 "EHLO
	light.bluelinux.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbZE2B4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 21:56:43 -0400
X-Greylist: delayed 1653 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 May 2009 21:56:43 EDT
Date: Fri, 29 May 2009 11:25:26 +1000
From: Daniel Stone <daniel@fooishbar.org>
To: "Eaton, Thomas G" <thomas.g.eaton@intel.com>
Cc: "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       "airlied@linux.ie" <airlied@linux.ie>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm: add connector and encoder types for MIPI displays
Message-ID: <20090529012526.GB22818@fooishbar.org>
Mail-Followup-To: Daniel Stone <daniel@fooishbar.org>,
	"Eaton, Thomas G" <thomas.g.eaton@intel.com>,
	"dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
	"airlied@linux.ie" <airlied@linux.ie>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4060059527C3A74384B5C4ED9D30CB998833847C@rrsmsx506.amr.corp.intel.com> <4060059527C3A74384B5C4ED9D30CB99884CF09D@rrsmsx506.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
In-Reply-To: <4060059527C3A74384B5C4ED9D30CB99884CF09D@rrsmsx506.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 28, 2009 at 12:16:23PM -0600, Eaton, Thomas G wrote:
> Added connector and encoder types for MIPI displays.
>=20
> Signed-off-by: Thomas G Eaton <thomas.g.eaton@intel.com>

I wonder if this is all really necessary to present to userspace, or if
MIPI/LVDS/et al should just fall under 'internally-connected panel'?

Cheers,
Daniel

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkofOYYACgkQUVYB1rKAgJS+LQCgi3CvFFEVoqnUSnOWSNq8fk0V
BYEAn1RfAvVp7kJbYnXkiQ+HXK97ZA9M
=y0Fe
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
