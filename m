Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbZFSWy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbZFSWy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbZFSWyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:54:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46517 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352AbZFSWyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:54:46 -0400
Date: Sat, 20 Jun 2009 08:54:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 00/21] ceph: Ceph distributed file system client v0.9
Message-Id: <20090620085443.42dab844.sfr@canb.auug.org.au>
In-Reply-To: <20090619224524.GB27322@kroah.com>
References: <1245450702-31343-1-git-send-email-sage@newdream.net>
	<20090619224524.GB27322@kroah.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__20_Jun_2009_08_54_43_+1000_MT7miujLop+WNSIf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__20_Jun_2009_08_54_43_+1000_MT7miujLop+WNSIf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 19 Jun 2009 15:45:24 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Fri, Jun 19, 2009 at 03:31:21PM -0700, Sage Weil wrote:
> > This is a patch series for v0.9 of the Ceph distributed file system
> > client (against v2.6.30).
>=20
> Oh, one other question, why put this in staging?  What is keeping it
> being accepted into fs/ like normal?

And if it is up to that, then please consider submitting it for linux-next
inclusion ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__20_Jun_2009_08_54_43_+1000_MT7miujLop+WNSIf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko8FzMACgkQjjKRsyhoI8zqLQCfWyN9kaUMoxP/CLPyzea1FdQX
11UAn18zYOZTGeJDv12ko/mEDhJAu1ek
=6I2+
-----END PGP SIGNATURE-----

--Signature=_Sat__20_Jun_2009_08_54_43_+1000_MT7miujLop+WNSIf--
