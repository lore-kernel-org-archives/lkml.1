Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbZKWJss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbZKWJss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 04:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZKWJsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 04:48:47 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:51609 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbZKWJsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 04:48:47 -0500
Subject: Re: [PATCH] Fixed bug in Wireless Extension Code
 (CONFIG_WEXT_CORE).
From: Johannes Berg <johannes@sipsolutions.net>
To: mike@mspradling.com
Cc: davem@davemloft.net, hugh.dickins@ticali.co.uk, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <1258936602-6110-1-git-send-email-mike@mspradling.com>
References: <1258936602-6110-1-git-send-email-mike@mspradling.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-bPgtQ65vucE3NO4T/AeZ"
Date: Mon, 23 Nov 2009 10:45:41 +0100
Message-ID: <1258969541.7094.138.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bPgtQ65vucE3NO4T/AeZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please send wireless patches to the correct list (linux-wireless) in the
future.

On Sun, 2009-11-22 at 19:36 -0500, mike@mspradling.com wrote:

> When CONFIG_WEXT_CORE is not enabled and CONFIG_WEXT_PRIV is enabled
> there currently is a few build errors.

This should never happen unless there's as bug in Kconfig, please
provide the config that creates this problem so we can fix that issue
rather than work around it. When PRIV is enabled but not CORE, this
patch may fix compilation but it doesn't fix that the configuration
makes no sense at all.

johannes


--=-bPgtQ65vucE3NO4T/AeZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLClnBAAoJEODzc/N7+Qma0igP/3TCisQRshKmhq5dHr7DtW5n
uBoUVgXbLHnY2ALt4M86QPpj/CUsk7ZbIegfYZQGFXJygPe1RZUDpzD9w+LfRvCI
llixeaE3HmZjHvxSPB/ey5RDiXftkcIeIgb5dGMrm58cA0iED1iAzNC3WoiF7WZf
T736K2UzO1cPJiFOO/H9qleu6qiKgUot94SYgnYAPh1TYYIfcDk5qXejkrMF6Sgq
HhfryVhn8/Nlil/Zu06LuavMfi1plbsfuqH9nzODx3vtMUnR70mPn6RUgUP6DBnB
8BNXXzPjxWzmJwdsbZ+4slnTRepOoS6oTgK3QIpKcD+Lp0Ltvm1Igtob6vNM6/Dg
4c0CLY4AJ6Bo+pma9yR6XhA4i22ag3SWYEY9eoPAh7zR5NIGJzCtwiZeBve6raLj
h7mvJ+QCxHbgzG/EXpAKJfb1YL8/Th+wrSwDSqxodLg/W972XCBXpEWl6r5f8oL8
yt66w/8ecOsNcbjGim9bBVTuni2ROjJqpKN6iz2Ue11VrgdMd6rwUyzay1H6LTiM
aJ4ZJpF1IWiFr7i5ZReKZR+2DiTyDOVk9CPgZP0zB86U7JM0rFYq4n/0JHuIx49/
KvZfQf/vLJVon2wDHocmci3FAO+vrfWgj1Wt4XbuMi21zRjyDo6lT7NRrBJata14
wQ5RTcHOKC9asL2oyy01
=5kDP
-----END PGP SIGNATURE-----

--=-bPgtQ65vucE3NO4T/AeZ--

