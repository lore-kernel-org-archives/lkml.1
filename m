Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbZKLPyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbZKLPyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 10:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbZKLPyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 10:54:52 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:38723 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbZKLPyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 10:54:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=K+99EwPpUV8UZsy/a+iHqadpdZzIwT9NEvoX1U3BnkCQ/eia/vMi1Bl7cCiJtL1CVt
         KpepRiLhMdBD7VJsEY7Rix4bl5UbGmDvybMBvVUAYJKO5QyCCeVwE/7yvxw9IZt4Ffhk
         V+QcpRglfwiSJJCaumdGNggbQxdSEZflo20l4=
Message-ID: <4AFC2FCC.5090103@gmail.com>
Date: Thu, 12 Nov 2009 10:54:52 -0500
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Patrick Mullaney <pmullaney@novell.com>,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       arnd@arndb.de, bridge@lists.linux-foundation.org, evb@yahoogroups.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] vbus: venet macvlan support
References: <20091110222632.24100.14884.stgit@mimic.site> <4AFC2D65.9040903@gmail.com> <4AFC2F71.1060408@trash.net>
In-Reply-To: <4AFC2F71.1060408@trash.net>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig446F7890475F406410D336E8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig446F7890475F406410D336E8
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Patrick McHardy wrote:
> Gregory Haskins wrote:
>> Patrick Mullaney wrote:
>>> (Applies to alacrityvm.git/master:34534534)
>>>
>>> This patchset implements a vbus venet device with a
>>> macvlan backend.
>> Thanks Pat, applied.
>=20
> As I mentioned in my response to these patches, the macvlan part
> need more work.

Yeah, I talked to Pat offline.  He is going to patch it incrementally as
its not a trivial problem to cleanup.  For the time being, they are
sitting in the alacrityvm tree, but they are not going upstream until
the macvlan stuff is resolved.  All but the last patch are not really my
business to push up, anyway.

In the meantime, Pat or others can enhance the work that he's done to
date, so I will carry them out-of-tree.

Kind Regards,
-Greg


--------------enig446F7890475F406410D336E8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkr8L8wACgkQP5K2CMvXmqHqZgCeL+DYwW8KLcxD1Ruo9SFTY4wo
sV4An2ADiWlbBiQtDTfj7R6FvI5XpgPs
=NKah
-----END PGP SIGNATURE-----

--------------enig446F7890475F406410D336E8--
