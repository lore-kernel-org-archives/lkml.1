Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbZEKJwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbZEKJwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129AbZEKJv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:51:57 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:45401 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbZEKJv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:51:56 -0400
Date: Mon, 11 May 2009 11:51:54 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com
Subject: Re: [PATCH 0/13] RFC ONLY - kdb for kgdb
Message-ID: <20090511095154.GQ25550@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
	kdb@oss.sgi.com
References: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com> <20090511091539.GM25550@hawkmoon.kerlabs.com> <20090511092342.GA23055@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-10402-1242035499-0001-2"
Content-Disposition: inline
In-Reply-To: <20090511092342.GA23055@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-10402-1242035499-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11/05/09  5:23 -0400, Christoph Hellwig wrote:
> On Mon, May 11, 2009 at 11:15:39AM +0200, Louis Rilling wrote:
> > Do you intend to support kdb modules? If yes, in which extent should th=
ey be
> > adapted?
>=20
> I think that would be a very low priority.  What would be useful is the
> hack to load debuginfo into kdb so that it can pretty-print arbitrary
> structures.  That alone would replace about 90% of the kdb modules I
> think.
>=20
> And yes, that code in current kdb is even more ugly than core kdb, so
> it would need a major cleanup first.

I was thinking about custom KDB modules, but I agree that most of them coul=
d be
replaced by pretty-print of arbitrary structures.

Thanks,

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-10402-1242035499-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKB/U6VKcRuvQ9Q1QRAtk2AKCPcnxS8OKwDKJetZurAhPF6Qf8zACfXyIp
RzR+q0YDW6WycbK4NZZcZUo=
=Ddqb
-----END PGP SIGNATURE-----

--=_bohort-10402-1242035499-0001-2--
