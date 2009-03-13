Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbZCMHtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbZCMHtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 03:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbZCMHsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 03:48:53 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:47939 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbZCMHsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 03:48:52 -0400
Date: Fri, 13 Mar 2009 08:48:49 +0100
From: Nico Schottelius <nico-linux-20090311@schottelius.org>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Nico Schottelius <nico-linux-20090311@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: [ipw3945-devel] X200 suspend status on -wl and -next
Message-ID: <20090313074849.GI30728@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090311@schottelius.org>,
	reinette chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net" <ipw3945-devel@lists.sourceforge.net>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Next Mailing List <linux-next@vger.kernel.org>
References: <20090311073030.GA5284@denkbrett.schottelius.org> <200903110946.23280.rjw@sisk.pl> <20090311085229.GB4495@denkbrett.schottelius.org> <20090311184407.GG8761@tuxdriver.com> <20090312142003.GF30728@denkbrett.schottelius.org> <20090312173042.GD3410@tuxdriver.com> <1236882742.13699.28.camel@rc-desk> <1236883633.13699.31.camel@rc-desk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+PbGPm1eXpwOoWkI"
Content-Disposition: inline
In-Reply-To: <1236883633.13699.31.camel@rc-desk>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-rc7-next-20090306-ikn x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+PbGPm1eXpwOoWkI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Happy Friday morning everybody,

reinette chatre [Thu, Mar 12, 2009 at 11:47:13AM -0700]:
> On Thu, 2009-03-12 at 11:32 -0700, Chatre, Reinette wrote:
> > On Thu, 2009-03-12 at 10:30 -0700, John W. Linville wrote:
> > > On Thu, Mar 12, 2009 at 03:20:03PM +0100, Nico -telmich- Schottelius =
wrote:
> > > > John W. Linville [Wed, Mar 11, 2009 at 02:44:07PM -0400]:
> > > > > Any chance you'd like to try wireless-testing to help to isolate
> > > > > possible sources of this problem?
> > > > >=20
> > > > > 	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-=
testing.git
> > > >=20
> > > > v2.6.29-rc7-17155-g2f7ab92 looks good (as in: wlan works after seve=
ral
> > > > suspends and resumes). But it seems you do not add the full kernel =
version:
> > > >=20
> > > > sgnx20002:/home/nico/wireless-testing# git describe
> > > > v2.6.29-rc7-17155-g2f7ab92
> > > > sgnx20002:/home/nico/wireless-testing# uname -r
> > > > 2.6.29-rc7-wl-ikn
> > > >=20
> > > > Which is the kernel built some seconds before.
> > >=20
> > > I don't know where you get the -ikn bits from, presumably from the
> > > iwlwifi project.  Given what you said above, it would seem you are
> > > getting your suspend/resume problems from them as well... :-(

-ikn is a suffix used for the x200 by me (hostname). It is appended, because
I've several different machines / configurations, but does not add any patch

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--+PbGPm1eXpwOoWkI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkm6D+EACgkQuL75KpiFGIzGGgCfaNnq0ledUZX99XOWA3kApdFw
VF8AoIHH6SvozwM1tVVsh2nOf7lsn/ri
=l39I
-----END PGP SIGNATURE-----

--+PbGPm1eXpwOoWkI--
