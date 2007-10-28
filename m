Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbXJ1Qz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbXJ1Qz3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 12:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXJ1QzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 12:55:21 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54930 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749AbXJ1QzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 12:55:20 -0400
X-Sasl-enc: VbOACP+9OHfw472qyVsFKjhc7z4g8tXPTiLfrETpT84O 1193590518
Message-ID: <4724BF06.30404@imap.cc>
Date: Sun, 28 Oct 2007 17:55:34 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Adrian Bunk <bunk@kernel.org>, Greg KH <greg@kroah.com>,
       Simon Arlott <simon@fire.lp0.eu>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: eradicating out of tree modules
References: <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de> <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com> <4721B77F.8070102@imap.cc> <20071026232653.GF30533@stusta.de> <47234F73.3040809@imap.cc> <20071028005555.GC23339@stusta.de> <4724557C.6000408@s5r6.in-berlin.de> <47247A1C.8010406@imap.cc> <47249E8C.4070001@s5r6.in-berlin.de>
In-Reply-To: <47249E8C.4070001@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDE974E33589F1A682D018F77"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDE974E33589F1A682D018F77
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 28.10.2007 15:37 schrieb Stefan Richter:
> Tilman Schmidt wrote:
>> Am 28.10.2007 10:25 schrieb Stefan Richter:
>>> You two are hypothesizing.
>> No, we're not. We're discussing the very real issue of whether
>> LSM should be amputated in such a way as to make life difficult
>> for out of tree security module developers.
>=20
> I still believe you are.  From what I understood, the API change had
> technical reasons.  (What I have read is that using security modules in=

> the form of loadable and unloadable kernel modules didn't make sense.)

The jury is still out on that, and it's not my area of expertise
anyway. But Adrian declared that making life more difficult for
out-of-tree module developers would in itself be a legitimate
reason for such a change, and that's what I'm disputing.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigDE974E33589F1A682D018F77
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHJL8OMdB4Whm86/kRAtTUAJ90ZarI7wlJPX+ZArsEhemxKQ0rWACeKtCR
LX8qqgi7ig0Pzqam8XJ0nOc=
=HWHY
-----END PGP SIGNATURE-----

--------------enigDE974E33589F1A682D018F77--
