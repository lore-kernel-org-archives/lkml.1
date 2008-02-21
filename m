Return-Path: <linux-kernel-owner+w=401wt.eu-S932697AbYBUU3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697AbYBUU3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763480AbYBUU3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:29:24 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:37477 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758052AbYBUU3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:29:23 -0500
Subject: Re: [PATCH] mac80211: check endianness/types in sparse runs
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, John Linville <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1203625535.20345.65.camel@brick> (sfid-20080221_202534_134890_BEDDDA07)
References: <1203503909.17534.14.camel@johannes.berg>
	 <20080220195913.GE21139@uranus.ravnborg.org>
	 <1203597776.20331.5.camel@johannes.berg>
	 <20080221200620.GA29352@uranus.ravnborg.org>
	 <1203624563.26341.15.camel@johannes.berg> <1203625535.20345.65.camel@brick>
	 (sfid-20080221_202534_134890_BEDDDA07)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hq8ag07WkkBdZMhKmo5l"
Date: Thu, 21 Feb 2008 21:29:03 +0100
Message-Id: <1203625743.26341.18.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hq8ag07WkkBdZMhKmo5l
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Clean, or did you specifically mean bitwise-clean?

bitwise-clean. But I don't do full-mac drivers so most of what you quote
I don't compile, and the mac80211-based drivers only have few problems.

johannes

--=-hq8ag07WkkBdZMhKmo5l
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR73fDqVg1VMiehFYAQKP8A//dFBtAJoTqy/Zkmhj8vP1367729JB2684
ah4AjpFyA7SayfspXqKsyP0CHsNnlm4bGn17f0PAsSJawZN7gcF65Mm1ENyIEHLp
mjplfpZ2Dt32jQ7uccQyEjx3FNZXtOuOve07L1wTRHGX3o8U2zgerQCRt2dudyFd
RBe3GH8xGz9agF+M738xo+pp56RbQugmpzCyKKTGCIaSTqME6e4OBKnLftJnx4VF
mf063EKOCdPmOOd9XtE381AYt3clBvp2U5d+De6iPIUeT8GWeLLb2Yk55F0oAFUR
UZ9hDJtZ3kAzD8lZ9Vxt1UOsb2ylBoqe8Hy6conQyHbl7blLrnjNi6U6wrWhCHPI
qj1VeoHI2VUEc54mvtdI2wguliFW77Lf8vkrxFSvlQ1enNTiXE6OIUNXI4zkZvIG
e32U3IwYsH9r8rnzZYdyErIXMnv3kykTLE9VNus84jwJdZ9Mi0GHBNLA2pF5JvIE
nb+GRRhbSgTFXyFRBC3mdrnXlWNkVjZgyWebO5QIhs3RKToAzV6utpu4Gthx7u1p
+fLu5REKtRh3SJV27eW+YSkPHi4iaGS/suuYsQBetaEUPppuuLNmTa57iJ2SBsLx
yP5pZhogh6uGyrJkZge7t1FhkGHwptWd6Cd+kDjp5wDs2JIqmsiSpepWs4fXG4q/
maYF+xRuCC0=
=M+ig
-----END PGP SIGNATURE-----

--=-hq8ag07WkkBdZMhKmo5l--

