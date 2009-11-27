Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbZK0CvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbZK0CvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 21:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZK0CvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 21:51:18 -0500
Received: from mail.gmx.net ([213.165.64.20]:47599 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752192AbZK0CvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 21:51:17 -0500
X-Authenticated: #25574588
X-Provags-ID: V01U2FsdGVkX19UA7ckXJFUA/EU5r1B8BGETaLyXXzc06yUOkB4Gx
	0koUilwhHzLIGZ
Date: Fri, 27 Nov 2009 15:51:48 +1300
From: Johannes Buchner <buchner.johannes@gmx.at>
To: linux-kernel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org
Subject: Fw: reiser4 git repo
Message-Id: <20091127155148.dcc5cdee.buchner.johannes@gmx.at>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_Nov_2009_15_51_48_+1300_iHYJ8QZk+s6fijQO"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Nov_2009_15_51_48_+1300_iHYJ8QZk+s6fijQO
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[ I sent this 2 days ago to linux-fsdevel@vger.kernel.org, maybe I'll
get more responses in here. ]

Hi!

I would like to keep a git repo up to date with current kernel
development, with reiser4 patched in. I am having trouble finding a
repo that provides reiser4. Is there one?

Some people may have noticed the last patch doesn't apply cleanly
anymore. I made a few lines of modifications in my local repo. Maybe
that repo would be interesting for others too*.

I plan to catch up with changes from kernel development on a
daily/weekly basis; my /home partition is reiser4, so I am fairly
serious about it.

At the moment, I fetch from torvalds/linux-2.6.git and=20
stable/linux-2.6.31.y.git. Am I missing any other repositories that I
should try to keep up with? (A fs subsystem maintainer repo?)
next/linux-next.git is probably moving too fast for me.

Cheers,
Johannes

* How hard is it to get a git.kernel.org repo?
--=20
http://jakeapp.com/ http://johannes.jakeapp.com/blog/



--=20
Emails k=F6nnen ge=E4ndert, gef=E4lscht und eingesehen werden. Signiere oder
versch=FCssele deine Mails mit GPG.
http://web.student.tuwien.ac.at/~e0625457/pgp.html

--Signature=_Fri__27_Nov_2009_15_51_48_+1300_iHYJ8QZk+s6fijQO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAksPPsgACgkQ7X1+MfqVcr2uAACfbmuE4VIoq5Mz7q0bFfIAsRCf
2RgAn3gs1Lay41+84jktK2uS813eTVPA
=Db+B
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Nov_2009_15_51_48_+1300_iHYJ8QZk+s6fijQO--
