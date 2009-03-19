Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbZCSSto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbZCSSto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbZCSStf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:49:35 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:53814 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbZCSSte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:49:34 -0400
Message-ID: <49C29441.1030501@novell.com>
Date: Thu, 19 Mar 2009 14:51:45 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Luis Henriques <henrix@sapo.pt>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 -tip] sched: Clean unused fields from struct rq
References: <20090318225137.GA3766@hades.domain.com> <20090318225428.GA3769@hades.domain.com> <20090319074949.GB17144@elte.hu> <49C232D4.7050004@novell.com> <20090319182327.GA3823@hades.domain.com>
In-Reply-To: <20090319182327.GA3823@hades.domain.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE7D93F1684FB5034A96CB341"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE7D93F1684FB5034A96CB341
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Luis Henriques wrote:
>
> With respect to the changes to the sched_debug ABI, from what I underst=
ood no
> one is using it at the moment, right?
>
>  =20

I am not aware of any users personally, but that doesn't mean a whole
heck of a lot ;)  Ingo and Peter probably have better insight here.

However, you did the proper thing from my perspective and bumped the
version number.  So even if there are users out there, it stands to
reason they will likely pick up on the change in a deterministic manner
anyway.  Therefore, IMO you are all set.

Thanks Luis,
-Greg


--------------enigE7D93F1684FB5034A96CB341
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknClEIACgkQlOSOBdgZUxmWLACgjhhUWUWgOjiY1E+Sk6KlH74C
1HcAniYz4W6ZEAfkx5SHwBGB4SvIFFqj
=e2vO
-----END PGP SIGNATURE-----

--------------enigE7D93F1684FB5034A96CB341--
