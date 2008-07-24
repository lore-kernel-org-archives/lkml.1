Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbYGXMJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbYGXMJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYGXMJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:09:16 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:37821 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbYGXMJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:09:16 -0400
Subject: Re: 22bb1be4d27... breaks hal (and NM)
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>,
       "John W. Linville" <linville@tuxdriver.com>,
       Jean Tourrilhes <jt@hpl.hp.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1216900631.7257.321.camel@twins>
References: <20080724115805.5466c217@mjolnir.drzeus.cx>
	 <1216899520.13587.49.camel@johannes.berg> <1216900631.7257.321.camel@twins>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KipZdDiOwxQBs3VOuP+c"
Date: Thu, 24 Jul 2008 14:08:09 +0200
Message-Id: <1216901290.13587.54.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KipZdDiOwxQBs3VOuP+c
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-24 at 13:57 +0200, Peter Zijlstra wrote:

> So you're not considering HAL as shipped by most (if not all) distros as
> anyone?
>=20
> If everybody would act like that, the next kernel wouldn't even manage
> to get rudimentary user-space up and running. Like we already changed
> all those systemcalls in glibc-head, who needs this kernel to boot on
> your old stuff anyway..
>=20
> Common,.. this is rediculous.

What the hell is wrong with you guys? I used to think it's accepted
practice to introduce a config option you can change away from the
default if you already know you are using new software that doesn't need
it, and if you are clueless just don't fucking touch the default until I
decide it's time to flip the default/remove the option because distros
are shipping new versions of the dependent software.

johannes

--=-KipZdDiOwxQBs3VOuP+c
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIiHCmAAoJEKVg1VMiehFYpJMQAI+5+Llx7f89zQDTqvPUWQnn
bvf2h9OTncMHY1DhAQh6l4H20rn5se16blwtBBK/L2PC3F5LylMqm64GMB83bBgo
wjnudYqBO2NpPCXwTUexubBFsiatuFKp21gU8dbgo+9F+vSgbgDxoHySOJhqLZ5r
LLgfDyya7u8rjIUXoLFuyOQD4gTZFfDjZ0DLSymst8uVnHCj1X/Wmy8hmjvon8+0
Do/eyJrf394pGJFPtkKpSwaj4uZBNIf4Z7eH3oj1pTP7e5PoiubmedefRJ17ziU8
/F2HrEy91E2YPkjBbckLSd73oUcxTO8tZR/gut2Zp+sU0q1CizQc82VYDU/n5agb
pz+Q4icuQCb5zDTVIq4aVYRRfWKuZ9SyFQrc1CcrTKzgK8NITTDINJGuEoMASwJH
u+5EPhMBzpENCoxc6QilJ35yZkd+xo3Wh5fQM3Wmv1gcuJLr4+IH7uwUuCqL4Epp
LfoBryfAgFYtfaHPHHeP8Qz9IegKPoDZNeYSLWnS9Yy4KgopYDeItmbeVX4XtuTy
tKIa/rn+GSj99i6LCbWyRWBlYvtyTes1uE69CJ9smaaHITu5GjNs1PkgUnGewbfE
Agu3066BBqg41CzjygJl5C27ARyZxwpsqlgT/Bvk4yZwKxkWyj7fVoc0+g31UaF5
Br5xFBXBhso1QfGjgL34
=7AjK
-----END PGP SIGNATURE-----

--=-KipZdDiOwxQBs3VOuP+c--

