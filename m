Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbXGNPtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbXGNPtA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 11:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbXGNPsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 11:48:52 -0400
Received: from mercury.sygneca.com ([83.142.230.29]:44408 "EHLO
	mx2.sygneca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbXGNPsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 11:48:51 -0400
Message-ID: <4698F04B.2080204@martinorr.name>
Date: Sat, 14 Jul 2007 16:48:27 +0100
From: Martin Orr <martin@martinorr.name>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070621)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_tiberius-8011-1184428128-0001-2"
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Stefano Rivoir <s.rivoir@gts.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org> <4693327E.6000006@gts.it> <alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org> <46947ADF.4080605@gts.it> <p73vecrxf0t.fsf@bingen.suse.de> <46951892.20406@martinorr.name> <alpine.LFD.0.999.0707111059200.3412@woody.linux-foundation.org> <469544D3.90004@martinorr.name> <alpine.LFD.0.999.0707111410430.20061@woody.linux-foundation.org> <20070711221626.GA25510@one.firstfloor.org>
In-Reply-To: <20070711221626.GA25510@one.firstfloor.org>
X-Enigmail-Version: 0.95.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_tiberius-8011-1184428128-0001-2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/07/07 23:16, Andi Kleen wrote:
> I just checked with today's gcc 4.2 (070711) freshly compiled and from =
a quick inspection=20
> the code looks correct again. So perhaps it has been already fixed?=20

It has indeed been fixed.  I tracked the bug down to gcc svn revision 126=
418
 (20070706) and the fix to revision 126487 (20070709).

Best wishes,

--=20
Martin Orr




--=_tiberius-8011-1184428128-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGmPBYZ6a/BjxtAMARAvulAKD02v2I0EFldnZQyaof/q9LxISILACeMBJJ
BaqHcy41QXfCr+XYeMWmytM=
=dUp/
-----END PGP SIGNATURE-----

--=_tiberius-8011-1184428128-0001-2--
