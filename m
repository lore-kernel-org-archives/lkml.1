Return-Path: <linux-kernel-owner+w=401wt.eu-S1764154AbYBTOXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764154AbYBTOXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 09:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761836AbYBTOXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 09:23:42 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51387 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbYBTOXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 09:23:41 -0500
Date: Thu, 21 Feb 2008 01:23:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: first tree
Message-Id: <20080221012332.dc1948ac.sfr@canb.auug.org.au>
In-Reply-To: <20080214160231.GC10713@shadowen.org>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
	<20080214160231.GC10713@shadowen.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__21_Feb_2008_01_23_32_+1100_IavXq2RlDjLH4u_H"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Feb_2008_01_23_32_+1100_IavXq2RlDjLH4u_H
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andy,

On Thu, 14 Feb 2008 16:04:36 +0000 Andy Whitcroft <apw@shadowen.org> wrote:
>
> As devout believers in testing things early we test -mm and -git releases
> as they drop.  I am keen that we are able to continue this with the -next
> tree once it gets going.  Having just pulled this tree its not obvious how
> I would communicate which tree I had tested.  I guess we could use the
> SHA1 of the actual head used, but that really is cumbersome for the poor
> people who have to check the results and actually report things to lkml.

I hope I have addressed this issue by tagging each tree with its date
i.e. todays was next-20080220.

> Also will you be producing any tarballs for these releases?  If so I
> would say they would definatly need to be against some common base, like
> against the nearest official tag "below".

I hadn't considered tarballs, but I will give it some thought.

Thanks for your thoughts.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__21_Feb_2008_01_23_32_+1100_IavXq2RlDjLH4u_H
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHvDfsTgG2atn1QN8RAgv6AJ4ndn+rmQtfVmf2xAmDq7SGI9qW5QCdH9d4
JSQ5BUhogQ0ifR3raX3lQUw=
=sXDK
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Feb_2008_01_23_32_+1100_IavXq2RlDjLH4u_H--
