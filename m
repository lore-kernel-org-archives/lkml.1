Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029Ab0ASXr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab0ASXr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 18:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755996Ab0ASXr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 18:47:58 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41096 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993Ab0ASXr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 18:47:57 -0500
Date: Wed, 20 Jan 2010 10:47:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: "Wu, Fengguang" <fengguang.wu@intel.com>, Andi Kleen <andi@firstfloor.org>,
       Linus <torvalds@linux-foundation.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: origin tree build warning
Message-Id: <20100120104752.7bedb9b9.sfr@canb.auug.org.au>
In-Reply-To: <20100119211117.GE10928@kroah.com>
References: <20100118150501.f6aa79e3.sfr@canb.auug.org.au>
	<20100118151401.dd8a9ef2.sfr@canb.auug.org.au>
	<6CADD16F56BC954D8E28F3836FA7ED7112A9CD50F8@shzsmsx501.ccr.corp.intel.com>
	<20100118164039.8da6403e.sfr@canb.auug.org.au>
	<20100119111226.c9405ac7.sfr@canb.auug.org.au>
	<20100119210514.GD10928@kroah.com>
	<20100119211117.GE10928@kroah.com>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Jan_2010_10_47_52_+1100__Aorv5LYrE1XiI9K"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Jan_2010_10_47_52_+1100__Aorv5LYrE1XiI9K
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, 19 Jan 2010 13:11:17 -0800 Greg KH <greg@kroah.com> wrote:
>
> Ick, no, you are correct, Wu's patch shouldn't have been sent to Linus
> yet.  I'll revert it, and then keep the fixes that were in my tree,
> which should make everything safe for the .34 merge.

Great, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Jan_2010_10_47_52_+1100__Aorv5LYrE1XiI9K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktWRKgACgkQjjKRsyhoI8xiqACdEWvCscJTZ+FJqYiHLTqVLGpB
9uUAniP16tis+gk3sr+Z94igRwqdrYM3
=X5mg
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Jan_2010_10_47_52_+1100__Aorv5LYrE1XiI9K--
