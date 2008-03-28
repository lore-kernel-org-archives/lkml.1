Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbYC1Exe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbYC1Exe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 00:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbYC1Ex1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 00:53:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50549 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbYC1Ex0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 00:53:26 -0400
Date: Fri, 28 Mar 2008 15:53:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 27
Message-Id: <20080328155316.a44e368d.sfr@canb.auug.org.au>
In-Reply-To: <20080327144505.GB18810@kroah.com>
References: <20080327183357.7c637aed.sfr@canb.auug.org.au>
	<20080327144505.GB18810@kroah.com>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__28_Mar_2008_15_53_16_+1100_hPpqtzj2bdzS8gGs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Mar_2008_15_53_16_+1100_hPpqtzj2bdzS8gGs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 27 Mar 2008 07:45:05 -0700 Greg KH <greg@kroah.com> wrote:
>
> Can you add my "linux drivers" tree at:
> 	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-0=
4-ldp/
> to the mix as well?  It should come after my 3 other trees.  It contains
> new drivers that are being worked on by the linux driver project group.

Are these drivers targetted at 2.6.26?  If so, I will add this at the end
(and drop it temporarily when it breaks).  If not, then it should wait
until after 2.6.25 is out.

> The code there isn't the best, but it is actively being worked on to
> clean up and get ready for merging, and should always build properly.
> If not, I'd like to know about it, as it passes my build tests on i386
> and x86-64.

That is promising.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__28_Mar_2008_15_53_16_+1100_hPpqtzj2bdzS8gGs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH7HnETgG2atn1QN8RAsTPAJ0XUrXnwCA46yMd2/QJ0GzETsUTrACggQzZ
HAi+ods66SY+IaChOMY9RS8=
=TOBi
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Mar_2008_15_53_16_+1100_hPpqtzj2bdzS8gGs--
