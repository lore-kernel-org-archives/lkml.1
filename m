Return-Path: <linux-kernel-owner+w=401wt.eu-S1752091AbZG3Ja2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbZG3Ja2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 05:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZG3Ja1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 05:30:27 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:55392 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZG3Ja0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 05:30:26 -0400
Subject: Re: [wireless] rt2870sta BUGs on shutdown,
 2.6.30.2->git.today+git.wireless.today
From: Johannes Berg <johannes@sipsolutions.net>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1248945770.7910.24.camel@marge.simson.net>
References: <1248945770.7910.24.camel@marge.simson.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Oz4NKLzOt6pDNAYwUzpq"
Date: Thu, 30 Jul 2009 11:29:55 +0200
Message-Id: <1248946195.8925.9.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.4 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Oz4NKLzOt6pDNAYwUzpq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-30 at 11:22 +0200, Mike Galbraith wrote:

> drivers/staging/rt2870/../rt2860/sta_ioctl.c

Sorry, but that '/staging/' thing in there means we cannot support this.
If you must, take your query to the staging list,
devel@driverdev.osuosl.org (according to MAINTAINERS).

johannes

--=-Oz4NKLzOt6pDNAYwUzpq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcWgPAAoJEODzc/N7+QmaDa0P+wScpaL0th5ecWdqHvV9jC9Y
wGh9DTS5MziRscXwsGzcxmkdyEIBpVVmdHglwOnP7jgOo99GkQ3UR/R2aVPLVTPq
pqva+auSStNY1HLilNhNvVtcTXt09bwwM6/X+3Gw+vgFdY8LLY3dg0k+L3X+N04O
IYpOfdDuVHo9x9dGEkEwcjRhG4aPGIWRTJc1YQvvP9tPYBb+7I6sNSGjTyUnz3cg
O9PHwdmxw7QKqqEi/i4pgtOZlwAlV+HJmKR6DclChOMSmuyPY/TjTsG5hCuh0JzI
c7wk3+4p6elx0DqobatkFvEV/VFT4yoqfwoL/qLaAVrSlPLkp5/j4suaGpQNlpZx
HyWwEn0V/5CfypovsLpS/gWDfX73R7iGsE2MlX/knGtXEMtKf0Sva4b2C9NK1y1Y
NoQrHUIu5sx1+ApBoZ+/hwFjGX994P7j0fsl5bTvwzEJLqiOLTGlcP5uTxQraEvp
IjKU7MUw0pfS7D3Q32CtqKMhJ6lpyKHB5pPo1kaKVn9mIy/EKJkk8JpTZBYMK/ah
xOAxZDyXdjl6OyPht+aU4HTIquR6PkqQwpzlHdagdlf4kdThhPFjkc5/QvzTfMsE
uevRgAlyqbZxDoYWbYfnmjMMCpXZOOFqm6B/tm8seyXx4ImF4EF65en//G2paXnF
9vpydD+8Z/drM28QPqiU
=+0+0
-----END PGP SIGNATURE-----

--=-Oz4NKLzOt6pDNAYwUzpq--

