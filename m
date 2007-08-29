Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbXH2OuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbXH2OuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 10:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbXH2OuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 10:50:10 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35682 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbXH2OuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 10:50:09 -0400
Date: Wed, 29 Aug 2007 07:50:03 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: Add power meters to Documentation/hwmon/sysfs-interface
Message-ID: <20070829145002.GQ32667@tree.beaverton.ibm.com>
References: <20070827211446.GG32667@tree.beaverton.ibm.com> <20070828015029.GA10107@khazad-dum.debian.net> <20070828131942.18449886@hyperion.delvare> <20070828164440.GL32667@tree.beaverton.ibm.com> <20070829111052.503a73a5@hyperion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hSZb4FHl1C2xfsUy"
Content-Disposition: inline
In-Reply-To: <20070829111052.503a73a5@hyperion.delvare>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--hSZb4FHl1C2xfsUy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 29, 2007 at 11:10:52AM +0200, Jean Delvare wrote:

> I'm not sure if we want these "historical" files. We don't have them for
> the other input types, and I believe that it's not the driver's job to
> compute and export these values. If anyone cares about the history of

In the case of ibmpex, it is the _hardware_ that computes the historical
data; the driver merely exports what it sees.

--D

--hSZb4FHl1C2xfsUy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG1Yeaa6vRYYgWQuURAlgvAJ9g3FNI5fg2l0uCLKoNeRgJzemDAwCbBukX
KluMposcq7GvI4eRGe5g2Cg=
=RfZf
-----END PGP SIGNATURE-----

--hSZb4FHl1C2xfsUy--
