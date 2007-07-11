Return-Path: <linux-kernel-owner+w=401wt.eu-S933988AbXGKVCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933988AbXGKVCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933752AbXGKVAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:00:45 -0400
Received: from mercury.sygneca.com ([83.142.230.29]:37025 "EHLO
	mx2.sygneca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933534AbXGKVAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:00:43 -0400
Message-ID: <469544D3.90004@martinorr.name>
Date: Wed, 11 Jul 2007 22:00:03 +0100
From: Martin Orr <martin@martinorr.name>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070621)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_tiberius-4568-1184187635-0001-2"
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, Stefano Rivoir <s.rivoir@gts.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org> <4693327E.6000006@gts.it> <alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org> <46947ADF.4080605@gts.it> <p73vecrxf0t.fsf@bingen.suse.de> <46951892.20406@martinorr.name> <alpine.LFD.0.999.0707111059200.3412@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707111059200.3412@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_tiberius-4568-1184187635-0001-2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/07/07 19:01, Linus Torvalds wrote:
> Can you do
>=20
> 	make arch/x86_64/kernel/signal.s
>=20
> with both compilers, and post the results somewhere? It's probably goin=
g=20
> to be so large, and have so many trivial differences (register allocati=
on=20
> etc) that it will be hard-to-impossible to see the problem, but at leas=
t=20
> we can *try* to see if it might be obvious enough from comparing the=20
> assembly..

OK, they are at:
http://www.srcf.ucam.org/~mpo25/2007/linux-signal/

--=20
Martin Orr


--=_tiberius-4568-1184187635-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGlUTZZ6a/BjxtAMARAqRlAJ9GCc8+GMIg9Ymu3PR5khwtSREKBACeNyQL
W0k7sX9D2KsWHKnqYDbwdLo=
=Yt5d
-----END PGP SIGNATURE-----

--=_tiberius-4568-1184187635-0001-2--
