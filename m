Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYLFFlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYLFFlg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 00:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbYLFFl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 00:41:26 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35302 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbYLFFl0 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 00:41:26 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Geralt <usr.gentoo@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: Shebang - why are parameters not splitted on whitespace?
In-Reply-To: Your message of "Sat, 06 Dec 2008 01:04:52 GMT."
             <2375c9f90812051704oa80cafeif17909e332178d6e@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <fbdd0e50812030714md7dd899xeb8940798632b08b@mail.gmail.com> <2375c9f90812030756r5b8840e1u3980ddca8df27a6b@mail.gmail.com> <fbdd0e50812030929q65d2e805y49094dd67209be7e@mail.gmail.com> <fbdd0e50812030929s2d573981k46757c1b706f4cd5@mail.gmail.com>
            <2375c9f90812051704oa80cafeif17909e332178d6e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1228542083_5654P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 06 Dec 2008 00:41:23 -0500
Message-ID: <10860.1228542083@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1228542083_5654P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, 06 Dec 2008 01:04:52 GMT, Am=E9rico Wang said:
> On Wed, Dec 3, 2008 at 5:29 PM, Geralt <usr.gentoo=40googlemail.com> wr=
ote:
> > Hello,
> >
> > I should have anticipated this objection :-). I'm aware that this is
> > not consistent among Unix operating systems (you can find more about
> > it here =5B1=5D), but I was specifically refering to linux in this ca=
se
> > and why it handles the shebang arguments as one big string and not as=

> > single arguments for the application.
>=20
> I can't think out any strong reasons, maybe only becasue Linux develope=
rs
> prefer that approach.

And of course, =22whitespace=22 is a somewhat fungible concept.  'man bas=
h'
and read about =24IFS.

--==_Exmh_1228542083_5654P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJOhCDcC3lWbTT17ARAmcFAJ9JmN2aRBWHJRIzA9BaH1YB4ml8UgCdGB2G
ZHl9QB0xBFBqW4534M3/9lU=
=XDNk
-----END PGP SIGNATURE-----

--==_Exmh_1228542083_5654P--
