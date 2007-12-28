Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbXL1TPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbXL1TPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 14:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbXL1TPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 14:15:32 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:49783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXL1TPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 14:15:31 -0500
Subject: Re: [PATCH v4 7/8] debugfs: allow access to signed values
From: Johannes Berg <johannes@sipsolutions.net>
To: Christoph Hellwig <hch@lst.de>
Cc: Arnd Bergmann <ARNDB@de.ibm.com>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       Akinobu Mita <akinobu.mita@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mattias Nissler <mattias.nissler@gmx.de>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071228185832.GA4462@lst.de> (sfid-20071228_185955_765323_9702EDF1)
References: <20071219001955.055692620@polimi.it>
	 <1198080034.4747.15.camel@johannes.berg> <20071220131548.1d09cd62@morte>
	 <200712201347.15022.ARNDB@de.ibm.com>  <20071228185832.GA4462@lst.de>
	 (sfid-20071228_185955_765323_9702EDF1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sbce2iiqZVNKzLyeq37Z"
Date: Fri, 28 Dec 2007 20:15:08 +0100
Message-Id: <1198869309.4172.12.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sbce2iiqZVNKzLyeq37Z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2007-12-28 at 19:58 +0100, Christoph Hellwig wrote:
> On Thu, Dec 20, 2007 at 01:47:13PM +0100, Arnd Bergmann wrote:
> > Also, Christoph has recently posted a suggestion for how to improve
> > the interface to allow the 'get' operation to return an error:
> > http://patchwork.ozlabs.org/cbe-oss-dev/patch?id=3D14962
> >=20
> > I'd suggest consolidating the two changes in order to avoid merge
> > conflicts.
>=20
> Stefano, I couldn't find your complete patch series.  Where are the
> other 7 patches for that series?   Anyway, I'll post my series with
> the simple attribute chanegs ASAP and I'll Cc you.  If you send me the
> latest version of your patches I'll port it ontop of my patches.

There was only one, the seven other patches are plain wireless patches.

johannes

--=-sbce2iiqZVNKzLyeq37Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3VLO6Vg1VMiehFYAQLjxQ//UnG3CxRpY3fNAOfUhbyUfaTAaz3jgxDG
YQWVASx5j/dWNloXFu/4bFnonZExF/x/SBLtAIHT7p6MIHrTdCtFxa/I9hgf5p+d
/k3m3T/qg+I++9Dy0lsh34Z/gUg/xnCUezKXheq4OKhRUs0uQKhNedWdDy+Gu487
wFLIs7XzJjLsT1LFBtBuUq6AlDB57QeFgpi/AXOYHz8X7TWDWcH/gQC63sJWy0RN
Rez/2wybvGpfyuS1XMzy1EmJc/zQ5vPKnZVRxPVrB0qp5fJ547qPSjTkYSqboIX/
RcfqPnivbMkYCs3LRBvzPNtXVmn1FPzD+G/oOZTwoiNDdyLZWte8aN68tEkCXbh2
fvl5yjDGGnRpwfI6NCebJG4gaPq52PIgDieGAiih+lPXq8d0vwixRUgyVd1/8OAm
cglGvyBlgw96ZJGmLiguQGq+eIhCrGvO5eOyWeNgqs5L0QYNnW1Dnqh0dvdod52D
blAUIvCPrfhz5PVbnT299TYUqkb1J9dFQLf/xSwpwMsZECzTP5Fg5oRP+d4Zmj0/
F2pPRzaoqlaifa45poUfxDo2zeofs8D8p+txuc/RrJiV5jcb8YmIwet63KW3C18m
0Ev3J0N9BfAR7e+5vKxm8WGjwlYBEtVMSzbhXl98s/n+hq/0uY1Ro9tzCxYI4grM
Y7hxAL0f/2M=
=zTCb
-----END PGP SIGNATURE-----

--=-sbce2iiqZVNKzLyeq37Z--

