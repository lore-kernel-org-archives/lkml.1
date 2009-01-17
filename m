Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbZAQFAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbZAQFAa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 00:00:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbZAQFAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 00:00:17 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38925 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbZAQFAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 00:00:15 -0500
Date: Sat, 17 Jan 2009 16:00:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       Prarit Bhargava <prarit@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Tony Luck <tony.luck@intel.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: linux-next: build problem with nfs tree (Was: Re:
 [mmotm][PATCH] fix ia64 build error)
Message-Id: <20090117160002.077e4802.sfr@canb.auug.org.au>
In-Reply-To: <24484.1232167432@redhat.com>
References: <20090116134930.68e783aa.sfr@canb.auug.org.au>
	<20090115200315.EBE3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20090115093514.f3f6b8ff.akpm@linux-foundation.org>
	<20090116124949.7828a559.sfr@canb.auug.org.au>
	<20090115175917.8e0ae536.akpm@linux-foundation.org>
	<24484.1232167432@redhat.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__17_Jan_2009_16_00_02_+1100_TLQE.dRiOIUdm9FO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__17_Jan_2009_16_00_02_+1100_TLQE.dRiOIUdm9FO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Sat, 17 Jan 2009 04:43:52 +0000 David Howells <dhowells@redhat.com> wrot=
e:
>
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > There was another problem with the fscache code as well.  Also, this was
> > reported the day before yesterday and got no response.
>=20
> I've been flying to Tasmania for LCA and spending much time sitting aroun=
d in
> too many different airports.

Sorry about that ... it should have occurred to me.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__17_Jan_2009_16_00_02_+1100_TLQE.dRiOIUdm9FO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklxZdIACgkQjjKRsyhoI8znjQCfW5pr1/zuba6WPMtqJAw4SARu
hm4AoIfegBFqf4J/6zqa1p/XoUTI9Qs4
=z3xG
-----END PGP SIGNATURE-----

--Signature=_Sat__17_Jan_2009_16_00_02_+1100_TLQE.dRiOIUdm9FO--
