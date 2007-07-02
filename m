Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbXGBWI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbXGBWI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 18:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbXGBWIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 18:08:22 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:43852 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbXGBWIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 18:08:21 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Suspend2 is getting a new name.
Date: Tue, 3 Jul 2007 08:08:26 +1000
User-Agent: KMail/1.9.6
Cc: nigel@suspend2.net, LKML <linux-kernel@vger.kernel.org>
References: <200707021730.57066.nigel@nigel.suspend2.net> <46894F8F.3070607@tmr.com>
In-Reply-To: <46894F8F.3070607@tmr.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1580142.zbKVVbZEyr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707030808.26802.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1580142.zbKVVbZEyr
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Tuesday 03 July 2007 05:18:39 Bill Davidsen wrote:
> Nigel Cunningham wrote:
> > Hi all.
> >=20
> > Suspend2's name is changing to "TuxOnIce".
> >=20
> > This is for a couple of reasons:
> >=20
> > In recent discussions on LKML, the point was made that the word "Suspen=
d"=20
is=20
> > confusing. It is used to refer to both suspending to disk and suspendin=
g=20
to=20
> > ram. Life will be simpler if we more clearly differentiate the two.
> >=20
> > The name Suspend2 came about a couple of years ago when we made the 2.0=
=20
> > release and started self-hosting. If we ever get to a 3.0 release, the=
=20
name=20
> > could become even more confusing! (And there are already problems with=
=20
people=20
> > confusing the name with swsusp and talking about uswsusp as version 3!).
> >=20
> > http://www.suspend2.net is still working at the moment, but we'll shift=
 to=20
> > http://www.tuxonice.net over the next while. The wiki and bugzilla are=
=20
> > already done; email will remain on suspend2.net for a little while and =
git=20
> > trees will be renamed at the time of the next stable release.
> >=20
> I guess this is "good news, bad news" time. The good news is that the=20
> "suspend with working resume" project is still active, the bad news is=20
> that making provisions for long term out of mainline operation sounds as=
=20
> if you have no hope of getting this code into the mainline kernel. :-(

Let's not turn this into a flamewar, please. This is just a name change,=20
nothing more.

As far as I know, the desire on Rafael's part and mine is still to get at=20
least some of the functionality merged. The only reason this isn't happenin=
g=20
yet is that we're both busy with other aspects of the work. Rafael is=20
focussing on infrastructure issues, I'm focussing on minimising the diff an=
d=20
finishing off cleaning up and adding comments to functions.

Regards,

Nigel

--nextPart1580142.zbKVVbZEyr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGiXdaN0y+n1M3mo0RAkChAJ43alSSnC8IMn6f6Ht7JUkEXzgyNgCfcJax
elif76rFquQM5s5Z+XT4MvY=
=BC8d
-----END PGP SIGNATURE-----

--nextPart1580142.zbKVVbZEyr--
