Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab0BUKn5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 05:43:57 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:49592 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab0BUKn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 05:43:56 -0500
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <2375c9f91002210151i6fe3f769k72a8a6a3485d8cf5@mail.gmail.com>
References: <1264740107.20211.53.camel@pasglop>
	 <1266485775.6539.6.camel@jlt3.sipsolutions.net>
	 <alpine.LFD.2.00.1002180825000.4141@localhost.localdomain>
	 <1266518735.3829.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002192313j3fb84acje4c286c4f86457f3@mail.gmail.com>
	 <1266656213.5347.0.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200106j56b0298ds1a425fde8983d988@mail.gmail.com>
	 <1266665331.12525.0.camel@jlt3.sipsolutions.net>
	 <20100220134447.GA3000@hack>
	 <1266674268.18465.6.camel@jlt3.sipsolutions.net>
	 <2375c9f91002210151i6fe3f769k72a8a6a3485d8cf5@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QX7pbvLqD6VSdHZLoCwp"
Date: Sun, 21 Feb 2010 11:43:43 +0100
Message-ID: <1266749023.5468.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QX7pbvLqD6VSdHZLoCwp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Incidentally, the machine also freezes hard without any output at all if
I "echo 0 > /sys/.../cpu1/online".

johannes

--=-QX7pbvLqD6VSdHZLoCwp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLgQ5cAAoJEODzc/N7+QmaleoP/iVnhYznMthk/aSoHY1S1kJ7
Y2woClyUZGJoTwxOocW335vuHsFb7zZtFOTf2R562AJwTUxTAiK7b0RjDdmQlfPh
Tx1QGl62n2zTIYChG53tg25NgEC2BdH8Z+dweHmMhRWgQgvZMcsPEC9NmJ2sSerT
bG/ATbUYJA/nqaz359HUhJ6Pkl7UKckds5a8WIWJdJ4kGUZkWc1hHmWH8ZKnf+4S
4Ds3UWaHCiVZq/ABFsu9ojFUo6qDqi1EWClvD+I2z4TmpGfkUGrjCNA4G9NnQvEG
qypEg2RUTczzwJTncQqYAaACNjdypdQp4rjhdpPJmwJggEf+w27aydkMogVAfTE0
3PIMyWEh85J9gzc3LoUtWvAiroDxCPJ3tth8DZvLu5an6ybB9GMMazF8wOcE9gcR
96egK3XYvRDQ5KvX/JyEhjiVYneAoW63/2IjCQ4z3m5AmodpoqT8Fq18dwLFg1rG
v8I6tNiB3iiHV2Ci3mT3vv1c60tjagKlXlb3U6s/JhOy828OoVXdeULCFQmvhwcs
yDt0wzCqRf7SGYc5IOqLoBzguH4AfBIQjyq1JOH+nY5mVcITOvElnDbPkIQ2E7Nj
N7L4QarvQQpsXJcCWHa7lhI6dzYE+gCNMDCHr4zqSdLD/GrKs3JTBtfyaTneAzg0
rk5kS/mfF8TUMOedzzQP
=j409
-----END PGP SIGNATURE-----

--=-QX7pbvLqD6VSdHZLoCwp--

