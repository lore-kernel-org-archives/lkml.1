Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbYLLTJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbYLLTJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 14:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYLLTJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 14:09:04 -0500
Received: from virgo.iok.hu ([212.40.97.103]:46694 "EHLO virgo.iok.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbYLLTJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 14:09:03 -0500
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Dec 2008 14:09:03 EST
Date: Fri, 12 Dec 2008 20:09:00 +0100
From: Miklos Vajna <vmiklos@frugalware.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Simplified GIT usage guide
Message-ID: <20081212190900.GL5691@genesis.frugalware.org>
References: <20081212185347.GK5691@genesis.frugalware.org> <20081212182827.28408.40963.stgit@warthog.procyon.org.uk> <28996.1229108561@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JMKEfAmnQy+WzDHS"
Content-Disposition: inline
In-Reply-To: <28996.1229108561@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JMKEfAmnQy+WzDHS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 12, 2008 at 07:02:41PM +0000, David Howells <dhowells@redhat.co=
m> wrote:
> > Is there any reason you hide the tag object?
>=20
> What's a tag object?

http://www.kernel.org/pub/software/scm/git/docs/gitglossary.html#def_tag_ob=
ject

> > Using git clone --mirror would be much efficient, I think.
>=20
> 	warthog>man git-clone | grep mirror
> 	warthog1>

It's new in v1.6.0. You can just use git --bare init; git remote
add --mirror in older versions.

--JMKEfAmnQy+WzDHS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklCtswACgkQe81tAgORUJZdQgCgo9MZsAtjMJfHnxE+w2sEZf8G
wX8AnjbECEqU6+VXubsHOOx2NK7Bp42U
=RkPN
-----END PGP SIGNATURE-----

--JMKEfAmnQy+WzDHS--
