Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbZCLXYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbZCLXYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 19:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbZCLXYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 19:24:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40890 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbZCLXYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 19:24:42 -0400
Date: Fri, 13 Mar 2009 10:24:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org, linux-next@vger.kernel.org
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
Message-Id: <20090313102429.4997cb11.sfr@canb.auug.org.au>
In-Reply-To: <20090312205826.GA14205@uranus.ravnborg.org>
References: <200903120437.03837.rob@landley.net>
	<20090312095854.GA9398@uranus.ravnborg.org>
	<200903121503.37195.rob@landley.net>
	<20090312205826.GA14205@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__13_Mar_2009_10_24_29_+1100_EIr7UO26Kz2V.3x8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__13_Mar_2009_10_24_29_+1100_EIr7UO26Kz2V.3x8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Mar 2009 21:58:26 +0100 Sam Ravnborg <sam@ravnborg.org> wrote:
>
> Usual people read the announcement mails from Stephen and follow the inst=
ructions there.
> And many people keep an updated git tree around speeding up the process.

And that announcement (on LKML every day) says:

"I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
(patches at
http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/)."

The patches are releative to Linus' tree.  I assume most kernel
developers have access to fairly recent versions of Linus' tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__13_Mar_2009_10_24_29_+1100_EIr7UO26Kz2V.3x8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkm5ma0ACgkQjjKRsyhoI8xTAACgmpeaeEp2XhJ+qQw77eSGzYwX
X5UAoJPbhZ5E+cZivH09iJHEp8/O8C+3
=3+sc
-----END PGP SIGNATURE-----

--Signature=_Fri__13_Mar_2009_10_24_29_+1100_EIr7UO26Kz2V.3x8--
