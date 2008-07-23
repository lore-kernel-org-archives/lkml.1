Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbYGWDEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbYGWDEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 23:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYGWDEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 23:04:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49438 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbYGWDEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 23:04:42 -0400
Date: Wed, 23 Jul 2008 13:04:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, ak@linux.intel.com, mingo@elte.hu, tiwai@suse.de,
       linux-next@vger.kernel.org
Subject: Re: [PATCH 72/79] sysdev: Pass the attribute to the low level
 sysdev show/store function
Message-Id: <20080723130435.7a79f7e4.sfr@canb.auug.org.au>
In-Reply-To: <20080722211919.GA5669@suse.de>
References: <20080722051805.GA17373@suse.de>
	<1216703983-21448-72-git-send-email-gregkh@suse.de>
	<20080722134045.7f09ff29.akpm@linux-foundation.org>
	<20080722204939.GA3028@suse.de>
	<20080722140301.2a334f8c.akpm@linux-foundation.org>
	<20080722211919.GA5669@suse.de>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Jul_2008_13_04_35_+1000_YCz+Wr1+opZnLdCH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jul_2008_13_04_35_+1000_YCz+Wr1+opZnLdCH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, 22 Jul 2008 14:19:19 -0700 Greg KH <gregkh@suse.de> wrote:
>
> Andi any thoughts?

The patch
(sysdev-pass-the-attribute-to-the-low-level-sysdev-show-store-function.patc=
h)
has existed in the driver-core part of linux-next since July 4, but the
kernel/sched.c part only got added yesterday.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Jul_2008_13_04_35_+1000_YCz+Wr1+opZnLdCH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiGn8MACgkQjjKRsyhoI8xeRwCghlA1czotSe+Ap51YfX7OVAnU
5ncAnjrSIAeVXjNJT51nSKYrpRR88sfN
=YxNb
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jul_2008_13_04_35_+1000_YCz+Wr1+opZnLdCH--
