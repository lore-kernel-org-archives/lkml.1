Return-Path: <linux-kernel-owner+w=401wt.eu-S1751937AbZBDOn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbZBDOn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 09:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbZBDOnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 09:43:18 -0500
Received: from mx34.mail.ru ([194.67.23.200]:28497 "EHLO mx34.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbZBDOnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 09:43:18 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12606] fb_mmap: circular locking dependency on hibernation
Date: Wed, 4 Feb 2009 17:43:00 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc3-1avb; KDE/4.2.0; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.jNE.xuYiJB@chimera>
In-Reply-To: <pWZw1SZjMCH.A.jNE.xuYiJB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4609451.9OHcauY7sL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200902041743.08010.arvidjaar@mail.ru>
X-Mras: Ok
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4609451.9OHcauY7sL
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 4 of February 2009 13:24:06 Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me
> know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D12606
> Subject		: fb_mmap: circular locking dependency on hibernation
> Submitter	: Andrey Borzenkov <arvidjaar@mail.ru>
> Date		: 2009-01-27 18:37 (9 days old)
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D123308162731408&w=3D4

for me it is fixed with
http://marc.info/?l=3Dlinux-kernel&m=3D123365581406194&w=3D2=20

--nextPart4609451.9OHcauY7sL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmJqXYACgkQR6LMutpd94yIigCfZQtVS9FxvYb4wxBcouQp4yIj
g8MAnjurXaxW9J7216qbny8NfgCMknan
=wUKV
-----END PGP SIGNATURE-----

--nextPart4609451.9OHcauY7sL--
