Return-Path: <linux-kernel-owner+w=401wt.eu-S1760974AbZD1Hvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760974AbZD1Hvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 03:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760892AbZD1HvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 03:51:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:38143 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760898AbZD1HvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 03:51:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,259,1239001200"; 
   d="asc'?scan'208";a="136679461"
Subject: [Announcement] aer-inject 0.1: First release of PCIE AER software
 error injection tool
From: Huang Ying <ying.huang@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Andi Kleen <andi@firstfloor.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4mczJ1bjSDVWRIJlPLLo"
Date: Tue, 28 Apr 2009 15:51:18 +0800
Message-Id: <1240905078.6842.1148.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4mczJ1bjSDVWRIJlPLLo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

We are pleased to announce the first release of PCIE AER software error
injection tool.

aer-inject allows to inject PCIE AER errors on the software level into a
running Linux kernel. This is intended for validation of the PCIE driver
error recovery handler and PCIE AER core handler.

To use aer-inject, you need corresponding kernel patches.

Download location:

http://www.kernel.org/pub/linux/utils/pci/aer-inject/

Git tree:

git://git.kernel.org/pub/scm/utils/pci/aer-inject/aer-inject.git

Best Regards,
Huang Ying


--=-4mczJ1bjSDVWRIJlPLLo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkn2tW0ACgkQKhFGF+eHlpi9QwCfZqh+nRjqwEZxi7MMK0C4CppZ
AsgAnRtETRwHhRNKqJYyMianYK8S/aEH
=5qP0
-----END PGP SIGNATURE-----

--=-4mczJ1bjSDVWRIJlPLLo--

