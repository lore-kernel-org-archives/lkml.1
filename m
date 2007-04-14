Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbXDNHYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbXDNHYX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 03:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXDNHYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 03:24:23 -0400
Received: from john.hrz.tu-chemnitz.de ([134.109.132.2]:39076 "EHLO
	john.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbXDNHYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 03:24:23 -0400
From: Tobias Doerffel <tobias.doerffel@gmail.com>
To: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [3/3] 2.6.21-rc6: known regressions
Date: Sat, 14 Apr 2007 09:24:13 +0200
User-Agent: KMail/1.9.6
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070414003808.GU5907@stusta.de>
In-Reply-To: <20070414003808.GU5907@stusta.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1793037.7vp4no9uff";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704140924.17365.tobias.doerffel@gmail.com>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.1.8 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: aa86db5e7f3e85aa9355d5c307b12c26
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1793037.7vp4no9uff
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 14 April 2007 02:38:08 you wrote:
> This email lists some known regressions in Linus' tree compared to 2.6.20.
>
> If you find your name in the Cc header, you are either submitter of one
> of the bugs, maintainer of an affectected subsystem or driver, a patch
> of you caused a breakage or I'm considering you in any other way
> possibly involved with one or more of these issues.
>
> Due to the huge amount of recipients, please trim the Cc when answering.
>
> Subject    : Suspend to RAM doesn't work anymore  (ACPI?)
> References : http://lkml.org/lkml/2007/3/19/128
>              http://bugzilla.kernel.org/show_bug.cgi?id=8247
> Submitter  : Tobias Doerffel <tobias.doerffel@gmail.com>
> Handled-By : Rafael J. Wysocki <rjw@sisk.pl>
>              Len Brown <len.brown@intel.com>
> Status     : problem is being debugged
Already fixed in rc5-git9, see http://bugzilla.kernel.org/show_bug.cgi?id=8247

Tobias

--nextPart1793037.7vp4no9uff
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGIIGhHsjdpw2OaacRAusOAJ0VWPzhDVHWoxKraAc32My6+xXANQCfdc80
etqVN/ZPaiD18FNWMf2spwY=
=FQ/O
-----END PGP SIGNATURE-----

--nextPart1793037.7vp4no9uff--
