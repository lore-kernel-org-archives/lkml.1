Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbYIRXRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbYIRXRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 19:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755572AbYIRXRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 19:17:34 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:44758 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbYIRXRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 19:17:33 -0400
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27
	(rc5, rc6, probably others)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Steven Noonan <steven@uplinklabs.net>, Ingo Molnar <mingo@elte.hu>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>
In-Reply-To: <43e72e890809181610h3a7729d8s4c8484d97b21932e@mail.gmail.com> (sfid-20080919_011057_085624_6416966D)
References: <f488382f0809181123n55a4979eg1996bbc30fa47d54@mail.gmail.com>
	 <43e72e890809181134ybbec8fdxcb2a466aa17fe390@mail.gmail.com>
	 <43e72e890809181142n7738cd99g522e6688e68d11ce@mail.gmail.com>
	 <f488382f0809181200u9aa03fcv4fc70bd1be7acc71@mail.gmail.com>
	 <43e72e890809181344q416b5944w3332ee5a33db048c@mail.gmail.com>
	 <f488382f0809181449x7343aa7endff066cb5836a73c@mail.gmail.com>
	 <20080918220102.GE7408@tesla>
	 <43e72e890809181508w5232a14ewbf2bf18fe90a92d5@mail.gmail.com>
	 <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
	 <43e72e890809181610h3a7729d8s4c8484d97b21932e@mail.gmail.com>
	 (sfid-20080919_011057_085624_6416966D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zE7o6hXv06OLEw/g2PnP"
Date: Fri, 19 Sep 2008 01:16:49 +0200
Message-Id: <1221779810.23409.0.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zE7o6hXv06OLEw/g2PnP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-18 at 16:10 -0700, Luis R. Rodriguez wrote:
> On Thu, Sep 18, 2008 at 4:04 PM, Steven Noonan
> > I always get "1 megabit/sec". It actually measures (at best) to be a
> > throughput of 8mbits/sec, though the average (due to strange random
> > packet loss) is about 4mbits/sec. --
>=20
> Yeah, iwconfig reports a wrong rate, should be easy to fix but I
> haven't yet looked at it. If you can fix it it'd be appreciated.

the rate patch I posted today will fix it. not for .27 though

johannes

--=-zE7o6hXv06OLEw/g2PnP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0uFdAAoJEKVg1VMiehFYeB8QAIL4j68uwBueyVRKgyr9pX33
ka/Kb+6fcey3gp/yq1/pPNrd3kGgGACMC+PJeZd5cq9FnB/dGvL3w8EeDiaS6Kwb
uelBBSWEWcZ/rDiwY1W6m+nu3zenyKs1MARpYBYA2walmr8ybKnOJn0DVvKSym5U
tNyIYBKYVqw7c6brerL3IgbocpJL05T3viZGQNZFOiZAponJ/LmJLrNrMUVfe2YD
EJQhAeDNCJak1DR4blBUxpTj7U0uJVNPJAh4K4oGQn0iJ2IDWbmYOAvMB2K2EluL
egO12HAG7NiZ6aHb07jIpsZ6FT1R08yQ5LfDylIARcfAn29GaTuHD+AXYnrNmmGi
LkYc0LDtx1aF5J0X7XWYJxtDzuaW/yldWyfMHynTl7AZhkVIGgwXESSe+PMKUDow
Ty7HRkNQAjP1fLIrfYuv9bYmvboDvcSa8qhwavIf/3W0KZsEBVTKuKRHGqlXaW2Q
pM6PmB51qf+V0qqNDjjLVtUJp5DV352giOTVDit53KCU3yD4fbiJzWpHRCXk6tha
dMJVCrnqrq2nKxtwwyzbfAzX9uG9MA8b29QWCdZvvtA9B43xBJRWOVCVX1NChHm+
BSsS9o3GgjBkY16TSZ2nwRWY2D9qAW+eB+2Y/w+47j+CtTRj1Bh9q0NsJnpkIx9t
0IMlf0Cyx3zrhlbnzaQB
=aGaL
-----END PGP SIGNATURE-----

--=-zE7o6hXv06OLEw/g2PnP--

