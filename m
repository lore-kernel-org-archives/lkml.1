Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbZBDASj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbZBDASj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZBDASb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:18:31 -0500
Received: from ns.km10614-05.keymachine.de ([87.118.102.170]:44463 "EHLO
	km10614-05.keymachine.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751134AbZBDASa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:18:30 -0500
Date: Wed, 4 Feb 2009 01:18:04 +0100
From: Harald Braumann <harry@unheit.net>
To: Paul Menage <menage@google.com>
Cc: sean finney <seanius@seanius.net>, Gustavo Noronha <kov@debian.org>,
       debian-devel@lists.debian.org, linux-kernel@vger.kernel.org
Subject: Re: cgroup mount point
Message-ID: <20090204011804.08f2b35a@sbs173>
In-Reply-To: <6599ad830902031540ra4e00dejd844d584b0668a6e@mail.gmail.com>
References: <20090202200013.GU3643@vespa.holoscopio.com>
	<20090202214153.GV3643@vespa.holoscopio.com>
	<20090203102416.GA8886@redhat.com>
	<87ljsnzo4v.fsf@benfinney.id.au>
	<1233671913.8902.53.camel@abacate.horta>
	<6599ad830902030855h1753f4a4o3a303b4dbddf10de@mail.gmail.com>
	<20090203184915.GA10004@glandium.org>
	<20090203185117.GB3359@mini-me.seanius.net>
	<6599ad830902031114t7de1b570p4ed5ec497e2e150e@mail.gmail.com>
	<20090204003847.308cd0df@sbs173>
	<6599ad830902031540ra4e00dejd844d584b0668a6e@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fz4d6i=jf9XmiMiVynUJ9+J";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/fz4d6i=jf9XmiMiVynUJ9+J
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Feb 2009 15:40:39 -0800
Paul Menage <menage@google.com> wrote:

> On Tue, Feb 3, 2009 at 3:38 PM, Harald Braumann <harry@unheit.net>
> wrote:
> >
> > So, what's the problem with /dev/cgroups then? If shm/ and pts/
> > are allowed under /dev, wouldn't it be discriminating against
> > cgroups/, to not allow it there?
>=20
> Right, that's what I proposed a couple of emails earlier in this
> thread.

Sorry, I didn't mean to imply that you'd be against it, on the contrary,
I took your explanation as another argument for using /dev and
against /sys (/cgroups should not even be considered, IMHO).=20

The question was targeted at those, who oppose it.

Cheers,
harry


--Sig_/fz4d6i=jf9XmiMiVynUJ9+J
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmI3rwACgkQwMFqDB+mz27abgCgqI99o9cgglYAz/fpycAG44BE
Z3kAn30HqmWowpil0l5Fn2Tao97NHzeg
=MNL7
-----END PGP SIGNATURE-----

--Sig_/fz4d6i=jf9XmiMiVynUJ9+J--
