Return-Path: <linux-kernel-owner+w=401wt.eu-S1030574AbXCENos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030574AbXCENos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933457AbXCENos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:44:48 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:47459 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933017AbXCENor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:44:47 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: [patch 00/18] 2.6.18-stable review
Date: Mon, 5 Mar 2007 15:44:22 +0200
User-Agent: KMail/1.9.6
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
References: <20070221014927.GA3684@kroah.com> <200702211355.05539.caglar@pardus.org.tr> <20070226001824.GI29575@stusta.de>
In-Reply-To: <20070226001824.GI29575@stusta.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart34507492.pViSMQMrWj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200703051544.24041.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart34507492.pViSMQMrWj
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

26 =C5=9Eub 2007 Pts tarihinde, Adrian Bunk =C5=9Funlar=C4=B1 yazm=C4=B1=C5=
=9Ft=C4=B1:=20
> On Wed, Feb 21, 2007 at 01:55:04PM +0200, S.=C3=87a=C4=9Flar Onur wrote:
> > 21 =C5=9Eub 2007 =C3=87ar tarihinde, Greg KH =C5=9Funlar=C4=B1 yazm=C4=
=B1=C5=9Ft=C4=B1:
> > > Responses should be made by Friday February 23 00:00 UTC.  Anything
> > > received after that time might be too late.
> >
> > We have still some CVEish patches in our package which maybe you want to
> > consider adding into -stable.
>
> Below, I'll only look at the 2.6.18, 2.6.19 and 2.6.20 kernels.
>
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2006-4814
>
> fixed in:
> - 2.6.18.8
> - 2.6.19.2
> - 2.6.20
>
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2006-5749
>
> fixed in:
> - 2.6.20 (commit dab6df63086762629936e8b89a5984bae39724f6)
>
> missing in:
> - 2.6.18
> - 2.6.19
>
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2006-5753
>
> fixed in:
> - 2.6.20 (commit be6aab0e9fa6d3c6d75aa1e38ac972d8b4ee82b8)
>
> missing in:
> - 2.6.18
> - 2.6.19
>
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2006-5823
>
> fixed in:
> - 2.6.19.2
> - 2.6.20
>
> missing in:
> - 2.6.18
>
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2006-6053
>
> fixed in:
> - 2.6.19.2
> - 2.6.20
>
> missing in:
> - 2.6.18
>
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2006-6054
>
> fixed in:
> - 2.6.19.2
> - 2.6.20
>
> missing in:
> - 2.6.18
>
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2006-6333
>
> fixed in:
> - 2.6.19.1
> - 2.6.20
>
> problem not present in:
> - 2.6.18
>
> > * http://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2007-0006
>
> fixed in:
> - 2.6.19.5
>
> missing in:
> - 2.6.18
> - 2.6.20

So maybe 2.6.18 deserves another stable release :) ?


=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart34507492.pViSMQMrWj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iD8DBQBF7B63y7E6i0LKo6YRAmCiAJ9UubYkZ+CgSya8ty8KEDoN24aywACZASmo
k6ACXWqXXXru0V8tjWgB10g=
=R4ZA
-----END PGP SIGNATURE-----

--nextPart34507492.pViSMQMrWj--
