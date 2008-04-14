Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbYDNEta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbYDNEta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 00:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYDNEtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 00:49:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41090 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbYDNEtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 00:49:21 -0400
Date: Mon, 14 Apr 2008 14:49:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       David Miller <davem@davemloft.net>
Subject: Re: linux-next: Tree for April 10: generic pci_enable_resources()
 strikes again
Message-Id: <20080414144913.f4e1e215.sfr@canb.auug.org.au>
In-Reply-To: <20080414042847.GB24269@kroah.com>
References: <20080410181404.b76939a6.sfr@canb.auug.org.au>
	<200804102134.00997.m.kozlowski@tuxland.pl>
	<20080414114823.b20802fe.sfr@canb.auug.org.au>
	<20080414042847.GB24269@kroah.com>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Apr_2008_14_49_13_+1000_QlTXR.=oHMsHXiqE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Apr_2008_14_49_13_+1000_QlTXR.=oHMsHXiqE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Sun, 13 Apr 2008 21:28:47 -0700 Greg KH <greg@kroah.com> wrote:
>
> Yes, I haven't caught up with my emails, but yes, this will not go
> upstream for those arches that have had problems with it (like sparc64).
> I'll fix my tree up first thing Monday morning for this issue.

Thanks.  I will look for it tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Apr_2008_14_49_13_+1000_QlTXR.=oHMsHXiqE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIAuJNTgG2atn1QN8RAn3eAJoCwZbIhmiZmehoSpU/EY/RF4lcqgCfR/jQ
IaDbtvuDf1vUi7B1hUc2Qk4=
=bU4P
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Apr_2008_14_49_13_+1000_QlTXR.=oHMsHXiqE--
