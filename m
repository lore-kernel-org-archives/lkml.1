Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbYJCMuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbYJCMuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 08:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbYJCMub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 08:50:31 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:48054 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbYJCMu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 08:50:29 -0400
Message-ID: <48E61618.10102@novell.com>
Date: Fri, 03 Oct 2008 08:54:48 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Chirag Jog <chirag@linux.vnet.ibm.com>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, dvhltc@us.ibm.com, dino@in.ibm.com,
       Gilles.Carry@bull.net
Subject: Re: [RT PATCH 0/2] fix for BUG_ON crash in 26.5-rt9
References: <20080925123235.GA27916@linux.vnet.ibm.com> <20081003123745.17387.61782.stgit@dev.haskins.net>
In-Reply-To: <20081003123745.17387.61782.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5A43C008F7C2B8CBF73C0A44"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5A43C008F7C2B8CBF73C0A44
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Hi Chirag,
>
>  Please try the following patches applied to 26.5-rt9 and let me know w=
hat you
>  find.
>
> Hi Steve,
>   If these look good to everyone, please consider them for inclusion in=
 -rt10.=20
>
>  =20

I meant to add: this are build-tested only (now back to vacation time
for me, which means slave labor in the garage!).

I will catch up with you guys on Monday.

-Greg



--------------enig5A43C008F7C2B8CBF73C0A44
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkjmFhgACgkQlOSOBdgZUxlcUwCbBGKY4kUFg1wcwwk9ONl3IoWd
laoAoIZJ7sdpG7+qE5VNRgd0812LExd0
=H3dA
-----END PGP SIGNATURE-----

--------------enig5A43C008F7C2B8CBF73C0A44--
