Return-Path: <linux-kernel-owner+w=401wt.eu-S1762528AbYEVXkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762528AbYEVXkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 19:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758142AbYEVXkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 19:40:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57096 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756707AbYEVXkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 19:40:46 -0400
Date: Fri, 23 May 2008 09:40:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       ALSA development <alsa-devel@alsa-project.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] HG -> GIT migration
Message-Id: <20080523094038.6381e980.sfr@canb.auug.org.au>
In-Reply-To: <4835DAD8.2090204@keyaccess.nl>
References: <Pine.LNX.4.61.0805201314190.1798@tm8103-a.perex-int.cz>
	<200805211430.06653.linux@audioscience.com>
	<Pine.LNX.4.61.0805210805080.1798@tm8103-a.perex-int.cz>
	<s5hve18vtml.wl%tiwai@suse.de>
	<483415E7.5080402@keyaccess.nl>
	<s5hfxsbx27f.wl%tiwai@suse.de>
	<48341DF5.4090307@keyaccess.nl>
	<Pine.LNX.4.61.0805211517290.1798@tm8103-a.perex-int.cz>
	<48343465.2030905@keyaccess.nl>
	<s5h8wy3wvyv.wl%tiwai@suse.de>
	<48343FF4.8090107@keyaccess.nl>
	<20080522112412.4a8406fd.sfr@canb.auug.org.au>
	<4835DAD8.2090204@keyaccess.nl>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__23_May_2008_09_40_38_+1000_NExqeUfKNcErrm1X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_May_2008_09_40_38_+1000_NExqeUfKNcErrm1X
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rene,

On Thu, 22 May 2008 22:43:04 +0200 Rene Herman <rene.herman@keyaccess.nl> w=
rote:
>
> On 22-05-08 03:24, Stephen Rothwell wrote:
>=20
> > Linux-next is rebuilt every day based on Linus' current kernel.  I merge
> > all the trees I have been told about and fixup minor conflicts (sometim=
es
> > reverting commits, sometimes applying patches).  So everyday, linux-next
> > is completely new.  I do not care if the trees I am merging get rebased.
>=20
> This means you're going to redo all those (same) minor conflict fixups=20
> each day again, doesn't it? Or do you pass the fixups back to (one of)=20
> the conflicting trees?

I send email about them and most go away after a day or so i.e. something
changes to make the conflicts go away.  However, the saving grace here is
"git rerere" which remembers these conflicts and their resolutions for me
so I normally only have to fix them once.

> > Does that answer your question?
>=20
> But yes, it does, thanks.

OK, good.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__23_May_2008_09_40_38_+1000_NExqeUfKNcErrm1X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFINgR6TgG2atn1QN8RAjy3AJ0aL0tNueRTxFMV7yBWCsHTnJBFcQCfV1M6
lzim+nnDV4E3WDHCBbJHnOk=
=9CT3
-----END PGP SIGNATURE-----

--Signature=_Fri__23_May_2008_09_40_38_+1000_NExqeUfKNcErrm1X--
