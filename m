Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbZFWGHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbZFWGHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 02:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZFWGH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 02:07:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44525 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbZFWGH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 02:07:28 -0400
Date: Tue, 23 Jun 2009 16:07:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 23
Message-Id: <20090623160725.e6c7f733.sfr@canb.auug.org.au>
In-Reply-To: <20090623153357.61f4a9a2.sfr@canb.auug.org.au>
References: <20090623153357.61f4a9a2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__23_Jun_2009_16_07_25_+1000_A93vZt7q/MdJ/v_G"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Jun_2009_16_07_25_+1000_A93vZt7q/MdJ/v_G
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

$ git diff --shortstat -M stable..HEAD^
 556 files changed, 27596 insertions(+), 7123 deletions(-)
$ git diff --dirstat -M stable..HEAD^
   3.8% Documentation/vm/
   4.8% arch/x86/kvm/
   5.4% arch/x86/
   3.4% drivers/acpi/
   7.5% drivers/firewire/
   8.5% drivers/md/
   5.8% drivers/misc/
   4.3% drivers/scsi/
   6.9% drivers/watchdog/
  15.3% drivers/
   3.4% fs/
   6.1% include/linux/
  15.5% mm/

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__23_Jun_2009_16_07_25_+1000_A93vZt7q/MdJ/v_G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpAcR0ACgkQjjKRsyhoI8xVRACfZHjN+rYWip5bsuehrQZb8d61
T4sAn2pNInrGv/iJppeRuwr8voef5LD6
=L9kg
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Jun_2009_16_07_25_+1000_A93vZt7q/MdJ/v_G--
