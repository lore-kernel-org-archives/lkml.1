Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbZFVI0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbZFVI0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 04:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZFVI0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 04:26:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51754 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbZFVI0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 04:26:03 -0400
Date: Mon, 22 Jun 2009 18:26:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 22
Message-Id: <20090622182600.129da88e.sfr@canb.auug.org.au>
In-Reply-To: <20090622181920.496d160e.sfr@canb.auug.org.au>
References: <20090622181920.496d160e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Jun_2009_18_26_00_+1000_oVLT.JfXL_OIVNxd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Jun_2009_18_26_00_+1000_oVLT.JfXL_OIVNxd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Jun 2009 18:19:20 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Changes since 20090619:

The current "git diff --stat -M stable..HEAD^" ends like this:

	835 files changed, 46602 insertions(+), 14044 deletions(-)

So, we must be nearly there. :-)

$ git diff --dirstat -M stable..HEAD^
   3.8% Documentation/
   4.9% arch/arm/configs/
   6.6% arch/arm/
   4.3% arch/m68k/include/asm/
   3.0% arch/x86/kvm/
   3.3% arch/x86/
   3.6% arch/
   4.6% drivers/firewire/
   5.2% drivers/md/
   3.5% drivers/misc/
   4.7% drivers/mtd/
   4.0% drivers/pci/hotplug/
   3.2% drivers/pci/pcie/
   4.2% drivers/watchdog/
  14.9% drivers/
   7.1% fs/
   4.1% include/linux/
   9.5% mm/

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__22_Jun_2009_18_26_00_+1000_oVLT.JfXL_OIVNxd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko/QBgACgkQjjKRsyhoI8yE1ACeM0lp3apJHUp/8PjhZRYe8Bhu
eY0An3Fv1eH0FV3YmdM2KFGiror380kM
=mBD+
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Jun_2009_18_26_00_+1000_oVLT.JfXL_OIVNxd--
