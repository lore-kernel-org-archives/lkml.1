Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbYCTGRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbYCTGRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 02:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbYCTGRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 02:17:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50216 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbYCTGRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 02:17:09 -0400
Date: Thu, 20 Mar 2008 17:17:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Dan Williams <dan.j.williams@intel.com>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Theodore Tso <tytso@MIT.EDU>
Subject: Re: linux-next: Tree for March 20
Message-Id: <20080320171702.d7fca89b.sfr@canb.auug.org.au>
In-Reply-To: <20080320045719.GA26938@kroah.com>
References: <20080320143953.8d6b5a60.sfr@canb.auug.org.au>
	<20080320045719.GA26938@kroah.com>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__20_Mar_2008_17_17_02_+1100_lmbfYTk/IDvn_Qvf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Mar_2008_17_17_02_+1100_lmbfYTk/IDvn_Qvf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 19 Mar 2008 21:57:19 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Thu, Mar 20, 2008 at 02:39:53PM +1100, Stephen Rothwell wrote:
> >=20
> > I have started this tree by reverting the following:
> > driver-core/driver-core-remove-no-longer-used-struct-class_device.patch
> > 	should be merged late
> > driver-core/ib-convert-struct-class_device-to-struct-device.patch
> > 	conflicts with the infiniband tree
> > driver-core/pm-make-wakeup-flags-available-whenever-config_pm-is-set.pa=
tch
> > 	breaks non CONFIG_PM builds of drivers/serial/serial_core.c
>=20
> These should be fixed tomorrow, I have new ones in my inbox to solve
> these issues (I hope...)

Great, I look forward to it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__20_Mar_2008_17_17_02_+1100_lmbfYTk/IDvn_Qvf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH4gFiTgG2atn1QN8RAgiaAJ9Xr/UfLg4DtHPEFpfHuZ3B5tazsgCgkfCm
P29VJ2vrPMDSqSaJVrC5i8o=
=byML
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Mar_2008_17_17_02_+1100_lmbfYTk/IDvn_Qvf--
