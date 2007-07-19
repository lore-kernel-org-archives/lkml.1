Return-Path: <linux-kernel-owner+w=401wt.eu-S934478AbXGSCPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934478AbXGSCPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 22:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758696AbXGSCPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 22:15:10 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:51429 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758200AbXGSCPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 22:15:08 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATH 0/1] Kexec jump - v2 - the first step to kexec based hibernation
Date: Thu, 19 Jul 2007 12:15:04 +1000
User-Agent: KMail/1.9.6
Cc: "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1184483593.1898.98.camel@caritas-dev.intel.com> <20070718180420.02352d4f.akpm@linux-foundation.org>
In-Reply-To: <20070718180420.02352d4f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2351488.ktMTUd6rUM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707191215.05245.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2351488.ktMTUd6rUM
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Thursday 19 July 2007 11:04:20 Andrew Morton wrote:
> On Sun, 15 Jul 2007 15:13:13 +0800
> "Huang, Ying" <ying.huang@intel.com> wrote:
>=20
> >=20
> > The changelog between v1 and v2
> >=20
> > 1. The kexec jump implementation is put into the kexec/kdump
> >    framework instead of software suspend framework. The device
> >    and CPU state save/restore code of software suspend is called
> >    when needed.
> >=20
> > 2. The same code path is used for both kexec a new kernel and jump
> >    back to original kernel.
>=20
> I like the idea but I think I'll let people chat about it a bit more
> before looking at merging the patches, OK?

Please wait until you see a complete implementation that actually works. I'=
m=20
sitting here quietly, following (and now breaking) the "If you can't say=20
anything positive, don't say anything at all" line because I think that the=
=20
more into the implementation details people get, the uglier this is going t=
o=20
show itself to be. I'm perfectly willing to be proven wrong, but haven't se=
en=20
anything so far that's even begun to convince me otherwise.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart2351488.ktMTUd6rUM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGnskpN0y+n1M3mo0RAge8AJoCwiUagG8l1xI7rk+vYajJQgkt+wCg6QPU
PRSGoff64GJ4SvF1YCkgYBg=
=2IrP
-----END PGP SIGNATURE-----

--nextPart2351488.ktMTUd6rUM--
