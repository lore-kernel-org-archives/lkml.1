Return-Path: <linux-kernel-owner+w=401wt.eu-S1751027AbXCRFBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751027AbXCRFBY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 01:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbXCRFBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 01:01:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43694 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbXCRFBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 01:01:14 -0400
Date: Sun, 18 Mar 2007 16:01:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomasz =?UTF-8?Q?Noi=C5=84ski?= <noix@sphere.pl>
Cc: linux-kernel@vger.kernel.org, timm@kip.uni-heidelberg.de,
       arne.wiebalck@kip.uni-heidelberg.de
Subject: Re: more precise CPU time accounting for x86
Message-Id: <20070318160115.f07cf7a9.sfr@canb.auug.org.au>
In-Reply-To: <20070317164722.1fed2b27.noix@sphere.pl>
References: <20070317164722.1fed2b27.noix@sphere.pl>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__18_Mar_2007_16_01_15_+1100_7ymPY/BS.4wBs20S"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__18_Mar_2007_16_01_15_+1100_7ymPY/BS.4wBs20S
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Tomasz,

On Sat, 17 Mar 2007 16:47:22 +0100 Tomasz Noiński <noix@sphere.pl> wrote:
>
> I've written a small patch for more precise process CPU time accounting
> for processors with TSC.

You should have a look at the CONFIG_VIRT_CPU_ACCOUNTING on s390 and
powerpc.

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__18_Mar_2007_16_01_15_+1100_7ymPY/BS.4wBs20S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF/MegFdBgD/zoJvwRAkROAJ99j9IHlFZdGADv2pi616aFE95W1QCfTFPh
8vGA8KuCJ80CJAZuRDIoV48=
=jdq9
-----END PGP SIGNATURE-----

--Signature=_Sun__18_Mar_2007_16_01_15_+1100_7ymPY/BS.4wBs20S--
