Return-Path: <linux-kernel-owner+w=401wt.eu-S1762991AbYEWBES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762991AbYEWBES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 21:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbYEWBEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 21:04:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38312 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbYEWBED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 21:04:03 -0400
Date: Fri, 23 May 2008 11:03:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Switch apm to unlocked_kernel
Message-Id: <20080523110353.7a1360b5.sfr@canb.auug.org.au>
In-Reply-To: <20080522212204.177410b8@core>
References: <20080522212204.177410b8@core>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__23_May_2008_11_03_53_+1000_EegcVHwq9+5q7elt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_May_2008_11_03_53_+1000_EegcVHwq9+5q7elt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On Thu, 22 May 2008 21:22:04 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrot=
e:
>
> This pushes the lock a fair way down and the final kill looks like it
> should be an easy project for someone who wants to have a shot at it.

and makes some gratuitous stylistic changes as well.  Please don't do
that!

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__23_May_2008_11_03_53_+1000_EegcVHwq9+5q7elt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFINhf9TgG2atn1QN8RAviyAJ4x0cnNf2Esy3XjTgfMqYti9YmL2QCfdZ1u
5WqI7tImN3yl3UlB/qRuBhQ=
=qhO4
-----END PGP SIGNATURE-----

--Signature=_Fri__23_May_2008_11_03_53_+1000_EegcVHwq9+5q7elt--
