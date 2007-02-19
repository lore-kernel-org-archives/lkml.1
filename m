Return-Path: <linux-kernel-owner+w=401wt.eu-S1750819AbXBSKA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750819AbXBSKA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbXBSKA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:00:57 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:50033 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbXBSKA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:00:56 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG?] register_blkdev: failed to get major for device mapper
Date: Mon, 19 Feb 2007 11:01:02 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
References: <200702161437.34063.eike-kernel@sf-tec.de> <20070216160920.27c1167a.akpm@linux-foundation.org>
In-Reply-To: <20070216160920.27c1167a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1194680.IX0xHVM6LP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702191101.09192.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1194680.IX0xHVM6LP
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Andrew Morton wrote:
> On Fri, 16 Feb 2007 14:37:28 +0100
> Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:

> > I can't bring up my machine with root LVM anymore using x86_64. The same
> > machine from same kernel tree boots fine as x86. The error message is
> > quoted in subject. The tree is at
> > 86a71dbd3e81e8870d0f0e56b87875f57e58222b (for those not using git:
> > somewhere after 2.6.20).
>
> Does this fix it?  I don't see why it would, but this was recently added.

Yes. But now usb complains "unable to get a dynamic major for usb endpoints=
".=20
Nevertheless the USB mouse works.

Eike

--nextPart1194680.IX0xHVM6LP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBF2XVlXKSJPmm5/E4RAgu0AKCnKK3iFYAx5HKDklGw/YYZPzETWACfeZmo
8CJxnNBg3ocSVIJfHOLa2c4=
=FxQF
-----END PGP SIGNATURE-----

--nextPart1194680.IX0xHVM6LP--
