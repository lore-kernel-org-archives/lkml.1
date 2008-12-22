Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbYLVRLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbYLVRLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 12:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYLVRLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 12:11:40 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:33304 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbYLVRLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 12:11:39 -0500
Subject: Re: [PATCH 1/2] video: mbp_nvidia_bl: Add support for MacBook 5,
	MacBook Air 2, and MacBook Pro 5
From: Johannes Berg <johannes@sipsolutions.net>
To: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
Cc: Matthew Garrett <mjg@redhat.com>, Richard Purdie <rpurdie@rpsys.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4942CE33.2020403@inf.tu-dresden.de>
References: <4942CE33.2020403@inf.tu-dresden.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QC7jssc5RHFSMnCGQFXV"
Date: Mon, 22 Dec 2008 18:11:23 +0100
Message-Id: <1229965883.4406.0.camel@johannes>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QC7jssc5RHFSMnCGQFXV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-12 at 21:48 +0100, Mario Schwalbe wrote:
> This patch adds support for the new Apple models incorporating
> an Nvidia chipset. Apple still uses the same protocol as on older models,
> but the registers moved to a different address.

Can you tell me which tree this is against? I can't seem to apply it
against .28-rc9, should I be using something newer?

johannes

--=-QC7jssc5RHFSMnCGQFXV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJT8o5AAoJEKVg1VMiehFYWRcP/07PhkzNDv75Unn/c/OgwacN
v4XL0aWWZVf/n3s4bQ4fm5WALOIWtXn67mQ2QdROhWWsSBdrWggn3vLcNwLruL1u
tPXvmhNlCMpNnqS7srK0K1l4kJyaR4bal4YyJopf+R0l/iRcrvA6iS1qxaXwndOs
ZFUOrVzjQwXFbJQ+VK8V8hhsfXdt9RJs2lh8jtF1hbqM7nfKe8jrBq9ErTyeFRu9
7zx5yfCd1P42VrKCaE36C9lTvUDi60feev+0JVwRX0tuHt99j6wonf4QC6C0m9id
CSpVp/aW18J5EyMqqa+QInt/oD/HQQSasbV4wcvDltd7fsOO4owN+HOa7hSdmb2T
uYZDIhdIiG1tLGXYB1eMKr/MXHCT6flnSHLKSNkUXvB+fv+rHqFv3lDMaeLH0xQG
hRPzKevuscE0ViXjejnZN4Jg3IAr54P4FMNPNfNtPJ28ecgGAp8Jt87zBuWMUd0p
4ItJ07GCVnBm4m4JdDhPJZEn364bp33x0zOhk0zUT2h6EPXFI9kTpAXmDmCLV3vI
rfi4xWcQsC8nOM4Uud0+pu9vJJD2TQsQ6//E8LmkdYcSPf2iGuqHgc7yy/Y1Tro9
j08YuRnbDv0pS/B4RYY460JzouRCucLbPTRmlkctik0Ze+Ess7s1cW9bZM/JUGd0
W2ljMXHSYCD9bfk25AMC
=qH//
-----END PGP SIGNATURE-----

--=-QC7jssc5RHFSMnCGQFXV--

