Return-Path: <linux-kernel-owner+w=401wt.eu-S932313AbXFSTFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbXFSTFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932413AbXFSTFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:05:19 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49378 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932395AbXFSTFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:05:17 -0400
Date: Tue, 19 Jun 2007 12:06:37 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070619190637.GL9751@tree.beaverton.ibm.com>
References: <20070606013759.GI17143@linux-os.sc.intel.com> <20070606185829.GA26062@tree.beaverton.ibm.com> <20070606193514.GN17143@linux-os.sc.intel.com> <20070606231642.GH13751@tree.beaverton.ibm.com> <20070608005726.GO17143@linux-os.sc.intel.com> <20070618223819.GD9751@tree.beaverton.ibm.com> <20070618235434.GB7160@linux-os.sc.intel.com> <20070619005136.GF9751@tree.beaverton.ibm.com> <m1sl8nn82i.fsf@ebiederm.dsl.xmission.com> <20070619180003.GE7160@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibq+fG+Ci5ONsaof"
Content-Disposition: inline
In-Reply-To: <20070619180003.GE7160@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ibq+fG+Ci5ONsaof
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 19, 2007 at 11:00:03AM -0700, Siddha, Suresh B wrote:
> Anyhow, Darrick there is a general bug in this area, can you try this and
> see if it helps?

Er... that instantly locked up the system.

--D

--ibq+fG+Ci5ONsaof
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGeCk9a6vRYYgWQuURAlyEAJ93wPhYqf57DcL1NH8DdKhERYXN0QCghVcH
bfN67RdbeQhe/nmH4Jp0qQ4=
=uT08
-----END PGP SIGNATURE-----

--ibq+fG+Ci5ONsaof--
