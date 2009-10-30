Return-Path: <linux-kernel-owner+w=401wt.eu-S932465AbZJ3Pae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbZJ3Pae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 11:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932421AbZJ3Pad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 11:30:33 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:36565 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376AbZJ3Pac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 11:30:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=M7BoZKHE347fUYTlElEZLzxA080K1buD3fOeVaTyNa8J9VCbyhxHco2s6W3mctPvJ6
         DSj7WqZNCtBYSGcwMsSMLwtntGGNvhIir57UWSxN88JMe30wnpTMk1NI+vGPhR6w17xg
         KenhdBenZYCrnJ5cuPfwJDmHIggkZV9FiQmMU=
Message-ID: <4AEB068F.3020607@gmail.com>
Date: Fri, 30 Oct 2009 11:30:23 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 30
References: <20091030200916.e9331f66.sfr@canb.auug.org.au>
In-Reply-To: <20091030200916.e9331f66.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA3DD6397EDCD54BF79A446B7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA3DD6397EDCD54BF79A446B7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Stephen

Stephen Rothwell wrote:
> Hi all,
>=20
> Changes since 20091029:
>=20

< snip >

> Merging alacrity/linux-next
> CONFLICT (content): Merge conflict in drivers/net/Kconfig
> CONFLICT (content): Merge conflict in lib/Kconfig

So I've noticed this error in your reports for a while now, but I wasn't
quite sure if there was an action-item for me to address it.

Considering no one is complaining that the tree is broken, I assume
these kinds of conflicts are automatically resolved, but I am wondering
if there are steps I should take to prevent the conflict in the future?

Kind Regards,
-Greg



--------------enigA3DD6397EDCD54BF79A446B7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrrBo8ACgkQP5K2CMvXmqF2mgCaAyYKXqwliMbLSB14lm/H9nBo
b0wAn33uwQvcRM6QKTlhtsGA8dkOlp4J
=BKJP
-----END PGP SIGNATURE-----

--------------enigA3DD6397EDCD54BF79A446B7--
