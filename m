Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbZICSEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbZICSEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 14:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbZICSEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 14:04:49 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:44887 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbZICSEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 14:04:48 -0400
Subject: Re: Exporting kmemleak.h to userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <43e72e890909031100l5f28dd4cu30cf1e1c735e0e9d@mail.gmail.com>
References: <43e72e890909021729q7c40f907v7a81eaf5c8b73a61@mail.gmail.com>
	 <84144f020909022323na828156v4eb9a8497cadaef8@mail.gmail.com>
	 <1251983939.22485.18.camel@pc1117.cambridge.arm.com>
	 <1251984845.3336.25.camel@johannes.local>
	 <43e72e890909031100l5f28dd4cu30cf1e1c735e0e9d@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Ieko0jjRBxWdEhoUwL+S"
Date: Thu, 03 Sep 2009 20:04:20 +0200
Message-Id: <1252001060.9336.0.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.91 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ieko0jjRBxWdEhoUwL+S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-03 at 11:00 -0700, Luis R. Rodriguez wrote:

> Anyway my point was that userspace does not need kmemleak.h and we are
> providing it to userspace.

No, we're not providing it to userspace.

If you actually build userspace headers it won't be included.

johannes

--=-Ieko0jjRBxWdEhoUwL+S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKoAUhAAoJEODzc/N7+QmaRT0QAJBgbtMgfE68hahUoQTDMKEp
2gAkhTIBmrYhezJL2YxknL4HXeJr4tmMR9nyiWDFaZPG3dqbTN1Zo64S1kDmaWtP
YNvS5OgRGmV21S/NWfk7MBO7SXAINYnNsAI2ZsuF0PsybeG+EBBbz4i7qkFrjXKy
9T8Bki1pZW+RoSBLQJnRakE7sy8/wYuBhAdl1tEeNRdc5eteSJGSZ3NFjzWFuogb
lne9qbiE+jkonWu1kKNqbHAGfFMuY5tXxXoNoqJ6HGpUCn5QvfH1HzygRtY2AgQ8
P+OSUnk37EeIriJn7Nxd7E7+yZhlHfl9v10h3amwwIxTq+MfSFyU9ri4jyhUlBzb
Y5ryTeHFySg5oaIXdfosScLuBiurZcP0ygOtfAKD036Oz2lCvPasTrAGsdn+6o3t
CBlADPtCFNtXjg/hFC1UeZKQoBKtyRdHJY47prOdLEGf/FAoWoJdrLObYxfeR6yM
ovXfDcnSTc01amxHSNnJ4kP3z9KcHuTCskwOOrDQ5BvmSOIgaBOLq/IfKKeLRmIn
r1sK4A16jXIyDEbVoTQB7GTpckdEu2IVR5AsZaopuW4IyoCcvK5Xs9HXn5bQ3xEk
kl3+del7SJMqO1zovoDOAtHZlbQCHfMUiDxu2OOVOhJWYrAcp6cV7JgzioPYYbfr
Cz77qMMGP5CI89aBv/h7
=q3+N
-----END PGP SIGNATURE-----

--=-Ieko0jjRBxWdEhoUwL+S--

