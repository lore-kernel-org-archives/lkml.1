Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbXFSUsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbXFSUsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbXFSUsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:48:12 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50945 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbXFSUsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:48:11 -0400
Date: Tue, 19 Jun 2007 13:49:30 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070619204929.GM9751@tree.beaverton.ibm.com>
References: <20070606193514.GN17143@linux-os.sc.intel.com> <20070606231642.GH13751@tree.beaverton.ibm.com> <20070608005726.GO17143@linux-os.sc.intel.com> <20070618223819.GD9751@tree.beaverton.ibm.com> <20070618235434.GB7160@linux-os.sc.intel.com> <20070619005136.GF9751@tree.beaverton.ibm.com> <m1sl8nn82i.fsf@ebiederm.dsl.xmission.com> <20070619180003.GE7160@linux-os.sc.intel.com> <20070619190637.GL9751@tree.beaverton.ibm.com> <20070619195927.GF7160@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ucfHZChuBC0NsER/"
Content-Disposition: inline
In-Reply-To: <20070619195927.GF7160@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ucfHZChuBC0NsER/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 19, 2007 at 12:59:27PM -0700, Siddha, Suresh B wrote:

> hmm.. Please try this instead. This is intended only for debug. Based on your
> test results, we can comeup with a more decent fix.

This fixes the problem!  Hurrah!

--D

--ucfHZChuBC0NsER/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGeEFZa6vRYYgWQuURAoXVAKCEcoaivD3Yxpfjp4f1bSwOWLUNkwCePO++
+Gi3jy8GcnBVNSZKbCVi7e0=
=CS2Q
-----END PGP SIGNATURE-----

--ucfHZChuBC0NsER/--
