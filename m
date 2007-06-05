Return-Path: <linux-kernel-owner+w=401wt.eu-S934077AbXFEXzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077AbXFEXzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 19:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932478AbXFEXz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 19:55:29 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43235 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932331AbXFEXz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 19:55:28 -0400
Date: Tue, 5 Jun 2007 16:57:07 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070605235707.GB16074@tree.beaverton.ibm.com>
References: <20070601004427.GI30788@tree.beaverton.ibm.com> <20070605172310.GD17143@linux-os.sc.intel.com> <20070605173647.GC12782@tree.beaverton.ibm.com> <20070605181342.GE17143@linux-os.sc.intel.com> <20070605183300.GD12782@tree.beaverton.ibm.com> <20070605184015.GF17143@linux-os.sc.intel.com> <20070605200954.GE12782@tree.beaverton.ibm.com> <20070605211451.GG17143@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6zdv2QT/q3FMhpsV"
Content-Disposition: inline
In-Reply-To: <20070605211451.GG17143@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 05, 2007 at 02:14:51PM -0700, Siddha, Suresh B wrote:
=20
> Can you send us your system's dmesg aswell as output of /proc/interrupts?

http://sweaglesw.net/~djwong/docs/dmesg
http://sweaglesw.net/~djwong/docs/interrupts

--D

--6zdv2QT/q3FMhpsV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGZfhTa6vRYYgWQuURAn/8AJ9MYxl9NcwXenfFlgSQdRnNtJfIpgCglUlB
li35Q37Faus3vulkt6xR+bw=
=flyN
-----END PGP SIGNATURE-----

--6zdv2QT/q3FMhpsV--
