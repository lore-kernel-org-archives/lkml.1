Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085Ab0AJUQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab0AJUQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 15:16:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782Ab0AJUQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 15:16:05 -0500
Received: from nn7.de ([85.214.94.156]:51575 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab0AJUQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 15:16:04 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jan 2010 15:16:04 EST
Subject: 2.6.32-rc3-git display goes off with i915.powersave=1
From: Soeren Sonnenburg <sonne@debian.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BMQNQmpszDbLMFFnz/Sc"
Date: Sun, 10 Jan 2010 21:09:20 +0100
Message-ID: <1263154160.3187.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BMQNQmpszDbLMFFnz/Sc
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Dear all,

on my Samsung NC10 the latest kernel i915 driver with powersaving
enabled causes the dissplay to go randomly black (or white) after a
random time (few minutes usually).

The only way to recover from this is a suspend to ram cycle....

I've upgraded to the latest xorg-intel driver to see if it works with
that one - but no it does not. However, setting powersave=3D0 makes things
work again..

And it looks like I am not alone:

http://ikibiki.org//blog/2010/01/08/Xorg_tricks_for_Intel_users/

Soeren
--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-BMQNQmpszDbLMFFnz/Sc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJLSjPvAAoJEH82z1Wqh6p3eRAQAMyui5/NqRXaAm049lqKuqrN
SBbav3xkEkFXUycDJ6x4H1ZC9TUA8Tzg7xp+psUS1IimZbMKY38+gwdhxN5ljNS7
7Au23SaZVUDxMoEkc5xLqmG9FWMEbqzEQZnjAf1Z1BW4Gx6jwUTd24Humdpaj+Hn
E5qKQ2uMeGtR9u0cxvozQujTSF3YOZNIqnAPeyEZo1e4h5Vz/PeJTF29Da/mvChE
N8CJzJtW7eGeE31h+su865PrriDb9hK1VKeCPNIlTAaLNrmDFyd2TivqDXedA7T2
aPMaYXhovFBBKLdzdQnp48ioCC42IloOQVogOpC96kizR+n8Soi0EHbOE5KPhgXO
8trYFnYtYDd4ySgA3MguRdG2SQHK8GnfYIQdeZvvg33xYAG09tixh1LFZywDwiLt
AlxMzf+LGwYkbBZhrjyIbaY7ZEZ4Uc7v0kyQZceBLIGUPr4GZhXCA4QhbqoR8EQu
AyDNuyHdNw7fE6YPTvszhq3BNwrzf7lhXLGqnI9x5z7bxjSR/0nE44uvYKySjh9l
8ulefupziSxTv12CDUeInlR5zVi8zr32ONcds5JXVh1ZqKEuuBdAJ4wWogMNAywq
ppaH2TOFyF9A6MxDQmOno9cW2zwKz1mx/MtllnZXUvme3t9VXdkyIC7h7xbwHqwi
N0ZkXezuQLLts7dk8WEZ
=r/ah
-----END PGP SIGNATURE-----

--=-BMQNQmpszDbLMFFnz/Sc--
