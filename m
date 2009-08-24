Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbZHXHaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbZHXHaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 03:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbZHXHav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 03:30:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38426 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbZHXHat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 03:30:49 -0400
Date: Mon, 24 Aug 2009 17:30:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 19
Message-Id: <20090824173046.c4f67b80.sfr@canb.auug.org.au>
In-Reply-To: <20090819093528.GA16547@mail.oracle.com>
References: <20090819190233.86e78493.sfr@canb.auug.org.au>
	<20090819093528.GA16547@mail.oracle.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__24_Aug_2009_17_30_46_+1000_Gqb9YG4hmYUQIb0E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Aug_2009_17_30_46_+1000_Gqb9YG4hmYUQIb0E
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Joel,

[Sorry for being a bit slow]

On Wed, 19 Aug 2009 02:35:28 -0700 Joel Becker <Joel.Becker@oracle.com> wro=
te:
>
> On Wed, Aug 19, 2009 at 07:02:33PM +1000, Stephen Rothwell wrote:
> > Merging configfs/linux-next
> > CONFLICT (content): Merge conflict in fs/configfs/dir.c
>=20
> 	Silly question.  The last time I had a conflict in next, you
> emailed me the details.  How do I go about finding them on my own
> (without doing the complete merge you do)?

Not a silly question, really.  I have no idea if you can generate those
merge resolution diffs without actually doing the merge.

Thanks for fixing up the configfs tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__24_Aug_2009_17_30_46_+1000_Gqb9YG4hmYUQIb0E
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqSQaYACgkQjjKRsyhoI8ydIwCgvei+SlBGDyNLopVKGHzlhKOY
fbwAn2EurNI8dcijRJvdo+eLfSDNvgVm
=I5ai
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Aug_2009_17_30_46_+1000_Gqb9YG4hmYUQIb0E--
