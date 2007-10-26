Return-Path: <linux-kernel-owner+w=401wt.eu-S1764064AbXJZSdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764064AbXJZSdy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756441AbXJZSdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:33:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35825 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393AbXJZSdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:33:42 -0400
Date: Fri, 26 Oct 2007 11:34:48 -0700
From: John Johansen <jjohansen@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: jjohansen@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 00/45] AppArmor security module overview
Message-ID: <20071026183448.GC32415@suse.de>
References: <20071026064024.243943043@suse.de> <20071026073721.618b4778@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NKoe5XOeduwbEQHU"
Content-Disposition: inline
In-Reply-To: <20071026073721.618b4778@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--NKoe5XOeduwbEQHU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 26, 2007 at 07:37:21AM -0700, Arjan van de Ven wrote:
> On Thu, 25 Oct 2007 23:40:24 -0700
> jjohansen@suse.de wrote:
>=20
> before going into the LSM / security side of things, I'd like to get
> the VFS guys to look at your VFS interaction code.
>=20
yes, the vfs interaction definitely need their review.

> In addition, I'd like to ask you to put a file in Documentation/
> somewhere that describes what AppArmor is intended security protection
> is (it's different from SELinux for sure for example); by having such a
> document for each LSM user, end users and distros can make a more
> informed decision which module suits their requirements... and it also
> makes it possible to look at the implementation to see if it has gaps
> to the intent, without getting into a pissing contest about which
> security model is better; but unless the security goals are explicitly
> described that's a trap that will keep coming back... so please spend
> some time on getting a good description going here..
>=20
yes this is needed and a good idea in general

thanks
john

--NKoe5XOeduwbEQHU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFHIjNIi/GH5xuqKCcRAoKHAJ4ug09vREnC66L+OaRyNTzwiIFxAQCgiR3m
wPURivqzkNQihMZoUL6FoyA=
=XufD
-----END PGP SIGNATURE-----

--NKoe5XOeduwbEQHU--
