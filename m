Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbYITU7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbYITU7T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 16:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYITU7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 16:59:05 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:35574 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbYITU7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 16:59:02 -0400
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27
	(rc5, rc6, probably others)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Steven Noonan <steven@uplinklabs.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <43e72e890809201357y1413a151r85aad7cc16440cf4@mail.gmail.com> (sfid-20080920_225745_416096_AAE736FF)
References: <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
	 <alpine.LNX.2.00.0809190934001.22989@alcarin.uplinklabs.net>
	 <20080919175824.GA5626@senthil-lnx.users.atheros.com>
	 <20080919182322.GB7027@tesla>
	 <alpine.LNX.2.00.0809191630090.14961@alcarin.uplinklabs.net>
	 <20080919235305.GD11665@tesla>
	 <f488382f0809191701u2dbf8d22n6015c9f1f23c73be@mail.gmail.com>
	 <43e72e890809191813n95579f5h83e92b0ba1f95a44@mail.gmail.com>
	 <f488382f0809192029w601e0e72x5c3affc3dbe65118@mail.gmail.com>
	 <f488382f0809200821m6fe355feu2d9fb99ac3c7f712@mail.gmail.com>
	 <43e72e890809201357y1413a151r85aad7cc16440cf4@mail.gmail.com>
	 (sfid-20080920_225745_416096_AAE736FF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mthL+089pEEIp5Cj08k3"
Date: Sat, 20 Sep 2008 22:58:58 +0200
Message-Id: <1221944338.3023.8.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mthL+089pEEIp5Cj08k3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-09-20 at 13:57 -0700, Luis R. Rodriguez wrote:

> mcgrof@tesla ~/tmp/irq $ sar -f irqlog-storm.sar -A
> Invalid system activity file: irqlog-storm.sar
>=20
> Perhaps we its a different format than what my sar can read...

It changes like every release... Not a very useful thing, that.

johannes

--=-mthL+089pEEIp5Cj08k3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI1WQOAAoJEKVg1VMiehFYbyEP/3189JlMdjPh1vc20nmBTU3R
AilkuUG1IiLtp8N8gf66IG1ETM+GXmJMrTrimgXYfmA3Xgi9plGqegbjAVYNlouH
RHxapnzcpc5uuUsm+yXVwsesNsZ0QTZhMfmjDOLUDEQebbu90XaRipT912aw0X2i
KOJash7nhO1kiOj2s/fqP7q21PUL9Y0fMkJhuXEBG+0wlxw1bIw+sIlYao4L8WHY
CUvuYWYEvOu57kydkD+tgC2lnhiCc8b2S36R+ACGVM4vLuc2kCgJlwB/xmyqlgGw
piIxqGPEkyW4yEjQOPoWW6cR0pROKRC1xOZf4l6vhLFxv4c41ty0/56pJBd0uN0Y
oavN7BPeezq82VsOQV3tgmqXT6vlUeRhqH/tsdi9MHxApNJosjMQ1JBpkvVSzL0S
/kQ1BHBfVeTrAIqhKXgqzygRRAMlYs50FHFSJ/BPJuwrq8VA74u4yU9nTjkGZ7K5
x8y3nNYXgdmztrjVb0iUZXiqU26oOTVnxk9VVlguqvYnvkvlsxwAhTG0zDQ/CdM0
sYUL0sPROLIgpx2wWD+1w8D7owYGOK+sgxqzSI6Jl9l+1EeW2z6khggIvqKTY7+9
rNR25WSFUge8+znKjshvIM7OezMFcXTWfrnSw9qd5P1TBPf4z7jqbyN/U7IpFJRV
Qw62CFF2JgdDhe3q8Vui
=A5bn
-----END PGP SIGNATURE-----

--=-mthL+089pEEIp5Cj08k3--

