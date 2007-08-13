Return-Path: <linux-kernel-owner+w=401wt.eu-S945779AbXHMNrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945779AbXHMNrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934092AbXHMKRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:17:05 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:33903 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935177AbXHMKRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:17:02 -0400
Subject: Re: [PATCH] [121/2many] MAINTAINERS - CFG80211 and NL80211
From: Johannes Berg <johannes@sipsolutions.net>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <46bff948.otglyA7i5BhTYKIi%joe@perches.com>
References: <46bff948.otglyA7i5BhTYKIi%joe@perches.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-83cjBOzshVQtzzmO9fF1"
Date: Mon, 13 Aug 2007 12:19:25 +0200
Message-Id: <1187000365.27916.66.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-83cjBOzshVQtzzmO9fF1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-08-12 at 23:25 -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry

> +F:	include/linux/nl80211.h
> +F:	include/net/cfg80211.h
> +F:	net/wireless/core.*
> +F:	net/wireless/sysfs.*
> +F:	net/wireless/radiotap.c

I must've missed the original discussion surrounding this, are these
supposed to be regular match patterns? Is there a tool reading it? With
this and wireless extensions it'd probably be best to mark cfg80211 as
"everything in net/wireless/ but net/wireless/wext*" if possible.

johannes

--=-83cjBOzshVQtzzmO9fF1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwDAt/ETPhpq3jKURAkf0AJ0XVHkK+F1/AIlB3Y7SfEJGuXYXPwCggwVI
dii1Ye8jUKS+7U2pE+g+G7A=
=AQ+J
-----END PGP SIGNATURE-----

--=-83cjBOzshVQtzzmO9fF1--

