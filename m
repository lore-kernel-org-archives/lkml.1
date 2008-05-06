Return-Path: <linux-kernel-owner+w=401wt.eu-S1765828AbYEFJ2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765828AbYEFJ2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764061AbYEFJVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:21:22 -0400
Received: from light.bluelinux.co.uk ([195.10.223.138]:45671 "EHLO
	light.bluelinux.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765289AbYEFJVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:21:17 -0400
X-Greylist: delayed 1230 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 May 2008 05:21:17 EDT
Date: Tue, 6 May 2008 12:00:21 +0300
From: Daniel Stone <daniel@fooishbar.org>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@tungstengraphics.com>
Cc: Steven J Newbury <steve@snewbury.org.uk>, David Airlie <airlied@linux.ie>,
       DRI for Linux <dri-devel@lists.sourceforge.net>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26-rc1-git1 -- trying to get vblank count for disabled
	pipe 0
Message-ID: <20080506090021.GA2326@fooishbar.org>
Mail-Followup-To: Daniel Stone <daniel@fooishbar.org>,
	Michel =?iso-8859-1?Q?D=E4nzer?= <michel@tungstengraphics.com>,
	Steven J Newbury <steve@snewbury.org.uk>,
	David Airlie <airlied@linux.ie>,
	DRI for Linux <dri-devel@lists.sourceforge.net>,
	Miles Lane <miles.lane@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <481E5EE6.6090503@gmail.com> <1209975302.26326.263.camel@thor.sulgenrain.local> <1209991916.24777.8.camel@infinity> <1210059619.26326.354.camel@thor.sulgenrain.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <1210059619.26326.354.camel@thor.sulgenrain.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 06, 2008 at 09:40:19AM +0200, Michel D=E4nzer wrote:
> On Mon, 2008-05-05 at 13:51 +0100, Steven J Newbury wrote:
> > I'm also getting occasional lockups.  Often it's the window manager
> > (metacity) that locks up when attempting to move a window, restarting
> > the window manager unlocks X but attempting to move a window again
> > results in another lockup.  When it's locked up the pointer moves and vt
> > switching works but nothing else. =20
>=20
> That sounds like an input related X server bug, probably not related to
> the original problem.

(Which has subsequently been fixed in git.)

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIIB4kUVYB1rKAgJQRAupXAJ9/WEv2+y0tzNi5Jo9R7w1PoIX/qQCgnggC
VDzR4Fjg2Ydw5NYc9//Qt0g=
=BJSX
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
