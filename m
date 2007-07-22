Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbXGVNz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbXGVNz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 09:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbXGVNzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 09:55:06 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48625 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363AbXGVNzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 09:55:01 -0400
X-Sasl-enc: h++5+w8arB4cg8O2ZS6t/64XHqsAYNcwL3Iei+1O8co2 1185112499
Message-ID: <46A362CC.1030600@imap.cc>
Date: Sun, 22 Jul 2007 15:59:40 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: processor family setting for Pentium D
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2B1F7B2F6C9B8DA447982B4F"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2B1F7B2F6C9B8DA447982B4F
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Probably a stupid question, but I spent some time searching the net
for an answer without success:

What is the correct setting of the "Processor family" configuration
option for a 32 bit kernel which is going to run on an Intel
Pentium D 940 processor (cpu family 15, model 6)? It doesn't seem
to fit any of the available selections.

More generally, what is the correct way of selecting the processor
family option for a CPU whose name doesn't appear anywhere in the
prompts or help texts in arch/i386/Kconfig.cpu? I guess there must
be a way of deducing it from the content of /proc/cpuinfo, only I
cannot figure out how.

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig2B1F7B2F6C9B8DA447982B4F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGo2LVMdB4Whm86/kRAtuPAJ4wvnDlDbs+ZbERtBltL20LG+fbfQCfT+rS
Hzu6v9lsCdFWqTm2cVwGumk=
=Q2TH
-----END PGP SIGNATURE-----

--------------enig2B1F7B2F6C9B8DA447982B4F--
