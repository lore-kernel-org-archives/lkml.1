Return-Path: <linux-kernel-owner+w=401wt.eu-S1751267AbZHAXQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751267AbZHAXQP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 19:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbZHAXQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 19:16:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45882 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbZHAXQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 19:16:14 -0400
Date: Sun, 2 Aug 2009 09:16:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: tty tree change for linux-next
Message-Id: <20090802091605.eeebc7fa.sfr@canb.auug.org.au>
In-Reply-To: <20090801171815.GA15259@kroah.com>
References: <20090801043905.GA12779@kroah.com>
	<20090801164104.5e9b2f17.sfr@canb.auug.org.au>
	<20090801172245.1d3e8b31.sfr@canb.auug.org.au>
	<20090801171815.GA15259@kroah.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__2_Aug_2009_09_16_05_+1000_dAA8fa83tMf0xnx1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__2_Aug_2009_09_16_05_+1000_dAA8fa83tMf0xnx1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Sat, 1 Aug 2009 10:18:15 -0700 Greg KH <greg@kroah.com> wrote:
>
> Ok, that's not good at all, I just took the patches straight from Alan.
> I'll edit them up this weekend to work better (i.e. in the format that
> all of my other patches are in, pseudo-mbox headers, which both quilt
> and git seem to like.)

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__2_Aug_2009_09_16_05_+1000_dAA8fa83tMf0xnx1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp0zLUACgkQjjKRsyhoI8xT2ACgm5nUrjT95+XG0plpITz1V5CP
d1kAnjbWslpijwIfVYmJ/Jox2gpSzhRQ
=LERz
-----END PGP SIGNATURE-----

--Signature=_Sun__2_Aug_2009_09_16_05_+1000_dAA8fa83tMf0xnx1--
