Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbZBCXrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbZBCXrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZBCXrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:47:10 -0500
Received: from ns.km10614-05.keymachine.de ([87.118.102.170]:41074 "EHLO
	km10614-05.keymachine.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751025AbZBCXrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:47:09 -0500
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Feb 2009 18:47:09 EST
Date: Wed, 4 Feb 2009 00:38:47 +0100
From: Harald Braumann <harry@unheit.net>
To: Paul Menage <menage@google.com>
Cc: sean finney <seanius@seanius.net>, Gustavo Noronha <kov@debian.org>,
       debian-devel@lists.debian.org, linux-kernel@vger.kernel.org
Subject: Re: cgroup mount point
Message-ID: <20090204003847.308cd0df@sbs173>
In-Reply-To: <6599ad830902031114t7de1b570p4ed5ec497e2e150e@mail.gmail.com>
References: <20090202200013.GU3643@vespa.holoscopio.com>
	<1233606371.15779.32.camel@radis.liafa.jussieu.fr>
	<20090202205246.GA28593@glandium.org>
	<20090202214153.GV3643@vespa.holoscopio.com>
	<20090203102416.GA8886@redhat.com>
	<87ljsnzo4v.fsf@benfinney.id.au>
	<1233671913.8902.53.camel@abacate.horta>
	<6599ad830902030855h1753f4a4o3a303b4dbddf10de@mail.gmail.com>
	<20090203184915.GA10004@glandium.org>
	<20090203185117.GB3359@mini-me.seanius.net>
	<6599ad830902031114t7de1b570p4ed5ec497e2e150e@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/FO_5EjwSUBlivfstkaqlyC.";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/FO_5EjwSUBlivfstkaqlyC.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Feb 2009 11:14:03 -0800
Paul Menage <menage@google.com> wrote:

> On Tue, Feb 3, 2009 at 10:51 AM, sean finney <seanius@seanius.net>
> wrote:
> > or /proc/bus/usb or /dev/shm or /dev/pts... :)
> >
>=20
> /dev is a bit different though - even if it's mounted as a udev fs,
> you can create a new directory in there to act as a mount point.

So, what's the problem with /dev/cgroups then? If shm/ and pts/
are allowed under /dev, wouldn't it be discriminating against
cgroups/, to not allow it there?

Cheers,
harry

--Sig_/FO_5EjwSUBlivfstkaqlyC.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmI1YcACgkQwMFqDB+mz26lsACfSOowuLuKON+HiFFD6IMHhRUh
M+QAn2pq0I9cmXL+F7SNrAYRcv8xC481
=Fna4
-----END PGP SIGNATURE-----

--Sig_/FO_5EjwSUBlivfstkaqlyC.--
