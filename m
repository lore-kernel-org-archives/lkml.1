Return-Path: <linux-kernel-owner+w=401wt.eu-S1422778AbXBUSa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422778AbXBUSa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422777AbXBUSa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:30:26 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:58380 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422760AbXBUSaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:30:24 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] [patch 00/18] 2.6.18-stable review
Date: Wed, 21 Feb 2007 20:30:35 +0200
User-Agent: KMail/1.9.6
Cc: "Theodore Ts'o" <tytso@mit.edu>, Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       torvalds@linux-foundation.org, Justin Forbes <jmforbes@linuxtx.org>,
       linux-kernel@vger.kernel.org, Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
References: <20070221014927.GA3684@kroah.com> <200702211355.05539.caglar@pardus.org.tr> <20070221173445.GA16071@kroah.com>
In-Reply-To: <20070221173445.GA16071@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1217083.ZYKLbTuVfB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702212030.39807.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1217083.ZYKLbTuVfB
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

21 =C5=9Eub 2007 =C3=87ar tarihinde, Greg KH =C5=9Funlar=C4=B1 yazm=C4=B1=
=C5=9Ft=C4=B1:=20
> On Wed, Feb 21, 2007 at 01:55:04PM +0200, S.??a??lar Onur wrote:
> > 21 ??ub 2007 ??ar tarihinde, Greg KH ??unlar?? yazm????t??:
> > > Responses should be made by Friday February 23 00:00 UTC.  Anything
> > > received after that time might be too late.
> >
> > We have still some CVEish patches in our package which maybe you want to
> > consider adding into -stable.
> >
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2006-4814
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2006-5749
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2006-5753
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2006-5823
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2006-6053
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2006-6054
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2006-6333
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2007-0006
>
> Do you have a pointer to the patches for these fixes anywhere?

http://svn.pardus.org.tr/pardus/2007/kernel/kernel/files/CVE/ has all of th=
em=20
as you can see some of them backports grabbed from newer kernels/git trees

> And are you sure they are all for 2.6.18?  The first one above is for
> the 2.4 kernel tree :)

Yep, but that one still clearly applies on top of 2.6.18.7. I'm not sure th=
ey=20
have _valid cases_, i'm simply following the CVE announcements :)

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1217083.ZYKLbTuVfB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iD8DBQBF3I/Py7E6i0LKo6YRAnxzAJ9VBBtcIIx9wah0so8awTyhYqnqVQCfXYni
lOoQVqCnKnV4o1x9zVKQm9U=
=vY9A
-----END PGP SIGNATURE-----

--nextPart1217083.ZYKLbTuVfB--
