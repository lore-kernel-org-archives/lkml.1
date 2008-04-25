Return-Path: <linux-kernel-owner+w=401wt.eu-S1761695AbYDYJlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761695AbYDYJlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 05:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383AbYDYJlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 05:41:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50297 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbYDYJlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 05:41:14 -0400
Date: Fri, 25 Apr 2008 19:41:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: jbarnes@virtuousgeek.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: gregkh-02-pci tree is now gone
Message-Id: <20080425194108.78cdafb7.sfr@canb.auug.org.au>
In-Reply-To: <20080424225104.GA16529@kroah.com>
References: <20080424225104.GA16529@kroah.com>
X-Mailer: Sylpheed 2.5.0beta2 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__25_Apr_2008_19_41_08_+1000_UOvs_rOHnb8gmK30"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__25_Apr_2008_19_41_08_+1000_UOvs_rOHnb8gmK30
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 24 Apr 2008 15:51:04 -0700 Greg KH <greg@kroah.com> wrote:
>
> My gregkh-02-pci tree is now gone as Jesse is now the PCI maintainer.
> I'll let him tell you all where to get his PCI patch queue from as I
> have no idea.
>=20
> This means that my other trees have been renamed, so you might want to
> adjust your scripts accordingly:
> 	gregkh-01-driver_core 	->  gregkh-01-driver_core   (no change)
> 	gregkh-03-usb		->  gregkh-02-usb
> 	gregkh-04-ldp		->  gregkh-03-ldp

OK, I have fixed up my lists, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__25_Apr_2008_19_41_08_+1000_UOvs_rOHnb8gmK30
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIEac4TgG2atn1QN8RAu8ZAJ9VZu5nRJNSCRmBZaCZZ/4tIxRvpQCgjHpZ
73Q/7aL+LqR5GRvjwEi4fRY=
=05jf
-----END PGP SIGNATURE-----

--Signature=_Fri__25_Apr_2008_19_41_08_+1000_UOvs_rOHnb8gmK30--
