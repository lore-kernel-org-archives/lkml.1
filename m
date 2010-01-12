Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543Ab0ALQsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab0ALQsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 11:48:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295Ab0ALQsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 11:48:05 -0500
Received: from mail.lysator.liu.se ([130.236.254.3]:41012 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab0ALQsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 11:48:04 -0500
X-Greylist: delayed 1994 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jan 2010 11:48:03 EST
From: paran@lysator.liu.se (=?utf-8?Q?P=C3=A4r?= Andersson)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Eric Anholt" <eric@anholt.net>, "ykzhao" <yakui.zhao@intel.com>
Subject: Re: [Bug #14860] No DP-DVI output when laptop is docked
In-Reply-To: <omZ8aBZReyD.A.nn.1NlSLB@chimera> (Rafael J. Wysocki's message of
	"Sun, 10 Jan 2010 23:32:53 +0100 (CET)")
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
	<omZ8aBZReyD.A.nn.1NlSLB@chimera>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
Date: Tue, 12 Jan 2010 17:14:40 +0100
Message-ID: <87vdf7e1vz.fsf@nsc.liu.se>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).

It should still be listed.

I was without Internet connection last week, but that have been fixed
now so I will test the patch from ykzhao ASAP.

Regards,

P=C3=A4r Andersson

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAktMn/AACgkQyi5LJcueYEvkogCcCWP10JEhpXah59kFdFn7gq5W
KMEAn2VCvFthO7iUQWUDGOL4ulyulOu0
=P6pC
-----END PGP SIGNATURE-----
--=-=-=--
