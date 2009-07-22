Return-Path: <linux-kernel-owner+w=401wt.eu-S1753085AbZGVLhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbZGVLhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 07:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZGVLhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 07:37:23 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:57008 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbZGVLhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 07:37:23 -0400
Subject: Re: binary ftrace buffer format
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0907202148140.11494@gandalf.stny.rr.com>
References: <1247520189.4071.4.camel@johannes.local>
	 <alpine.DEB.2.00.0907202148140.11494@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9zE2K+QTm6xpuNeotfZn"
Date: Wed, 22 Jul 2009 13:36:49 +0200
Message-Id: <1248262609.10231.0.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9zE2K+QTm6xpuNeotfZn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-20 at 21:51 -0400, Steven Rostedt wrote:

> You can get the tool here:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git

Another thing that just crossed my mind -- is this a candidate for
tools/ maybe?

johannes

--=-9zE2K+QTm6xpuNeotfZn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKZvnOAAoJEODzc/N7+Qma3MsQAKv/Q7WqcbLeVmwdHkUR0MQ1
4kGUxMVlRM9QBA/nwEhK4f4sbkMx9FvulylwV7yCQsfgt273ZSPQEhUCBZcDOwuV
TGs/3aJ5OuPF5YNdoEGL1C3u+7k3WBTxj+wGVO4NX1X6XJi+p34D7P0ezqaPajC7
s3Vo3oHJoeIhcZMNv321PRiH9IZqn7UCz8ddANre6iWDcI8oVfuN9Su6sOaTnst0
h818cz+dpj/YyvRAcn/6AUj8OOc9WyiIYbEzFD30dPHnjXDcDrIIqdiymRcbiv32
Hwxwc2c78A47olXs7iBTuLpRpI584OuoyUaCupZx6r4618ZtcYabuZrK8oXJbinG
XEPDKihciHDY2+YG69FesSn1+izuCVO26xA9gbp8YOB1BH9QARhe3tgS5qqWgYmh
XXXDUJHVD68OT2WiXPpGEJbEKy1y06lkdODxc56CdyoTC2PiAfKrq5/79BNC6aVt
2sLh1A57Mmbvq14YGgPo3Lumo/oCng1P5nzSoJYpVqCsJZMutfHDfGPc3rYFNQx0
NTxm+nLGOzDsLfBCYHnLcICeJwKS/TiqoFrRi0cyN9hAWcUWqoCSy8vdZCyExr4U
QRTOhUrRJ646PW0obusym3QB88IDEWbbzyEDmHXsRVf45ut0Nbn/bs6IwG6DXpyx
tBcDIzsVIntgJp7tkUhT
=SA36
-----END PGP SIGNATURE-----

--=-9zE2K+QTm6xpuNeotfZn--

