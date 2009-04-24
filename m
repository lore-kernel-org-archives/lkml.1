Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbZDXBMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbZDXBMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 21:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZDXBL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 21:11:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:22485 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbZDXBLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 21:11:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,238,1239001200"; 
   d="asc'?scan'208";a="406349678"
Subject: Re: [PATCH] [4/4] x86: MCE: Fix EIPV behaviour with !PCC
From: Huang Ying <ying.huang@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>
In-Reply-To: <49F1077A.5030801@jp.fujitsu.com>
References: <20090407506.675031434@firstfloor.org>
	 <20090407150657.61C4E1D046E@basil.firstfloor.org>
	 <1240479838.6842.555.camel@yhuang-dev.sh.intel.com>
	 <49F1077A.5030801@jp.fujitsu.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eO2Tq3TbDK0mWQB5R0yM"
Date: Fri, 24 Apr 2009 09:11:53 +0800
Message-Id: <1240535513.6842.561.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eO2Tq3TbDK0mWQB5R0yM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-24 at 08:27 +0800, Hidetoshi Seto wrote:
> Huang Ying wrote:
>
> Or, should this patch be applied after committing some of Andi's patches?
> It means this patch targets a bug in Andi's patch set and the bug is not
> in 2.6.30-rc* yet.

Yes. I think you are right. I fix a "bug" that doesn't exist.

Best Regards,
Huang Ying


--=-eO2Tq3TbDK0mWQB5R0yM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknxEdYACgkQKhFGF+eHlpjmPACghTb4hslAiUKcCOMGVbBFaH6p
UDQAoIslTjmJvjAzVxgtUKr2uEHNMLxh
=13U8
-----END PGP SIGNATURE-----

--=-eO2Tq3TbDK0mWQB5R0yM--

