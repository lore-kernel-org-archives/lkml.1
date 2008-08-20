Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbYHTIxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbYHTIxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 04:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbYHTIx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 04:53:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36469 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755236AbYHTIxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 04:53:25 -0400
Date: Wed, 20 Aug 2008 18:53:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Takashi Iwai <tiwai@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, sam@ravnborg.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       sameo@openedhand.com
Subject: Re: linux-next: Tree for August 19 (mfd/ucb)
Message-Id: <20080820185314.c242f790.sfr@canb.auug.org.au>
In-Reply-To: <20080820075734.GA29002@flint.arm.linux.org.uk>
References: <20080819185454.d9c74915.sfr@canb.auug.org.au>
	<20080819170517.04d91de8.randy.dunlap@oracle.com>
	<20080819171658.4cdb8cd9.akpm@linux-foundation.org>
	<s5h7iacnn15.wl%tiwai@suse.de>
	<20080820075734.GA29002@flint.arm.linux.org.uk>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Aug_2008_18_53_14_+1000_gUtRl1/pvZC4qM4e"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Aug_2008_18_53_14_+1000_gUtRl1/pvZC4qM4e
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Aug 2008 08:57:34 +0100 Russell King <rmk+lkml@arm.linux.org.uk>=
 wrote:
>
> On Wed, Aug 20, 2008 at 09:49:58AM +0200, Takashi Iwai wrote:
> >=20
> > This one is because the superfluous inclusion of <asm-generic/gpio.h>.
> > Should have been fixed in the latest Russell's tree.
>=20
> Haven't merged the two fixes discussed just yet - I only got a reply
> from Stephen on his this morning.

I have added Takashi's patch to the end of linux-next for today and will
remove it tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Aug_2008_18_53_14_+1000_gUtRl1/pvZC4qM4e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkir23oACgkQjjKRsyhoI8yiZgCfdmAOW4GIO+DkdJupl50ar+AZ
l2UAoJXA3Dok+1VgT6tTPaHRcKrl0Ls3
=dMGX
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Aug_2008_18_53_14_+1000_gUtRl1/pvZC4qM4e--
