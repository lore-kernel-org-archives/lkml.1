Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbZKWX5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbZKWX5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbZKWX5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:57:42 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:35599 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZKWX5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:57:41 -0500
Subject: Re: kvm hangs w/o nolapic
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>, kvm <kvm@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091123190557.GA11359@amt.cnet>
References: <1258715515.7094.51.camel@johannes.local>
	 <20091120181815.GA8779@lenovo> <1258752341.7094.79.camel@johannes.local>
	 <20091123190557.GA11359@amt.cnet>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-YXw8rfSehlFSUiEbgzh7"
Date: Tue, 24 Nov 2009 00:57:13 +0100
Message-ID: <1259020633.7094.193.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YXw8rfSehlFSUiEbgzh7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-23 at 17:05 -0200, Marcelo Tosatti wrote:

> > QEMU PC emulator version 0.10.50 (qemu-kvm-devel-88), Copyright (c)
> > 2003-2008 Fabrice Bellard

> Can you please try git://git.kernel.org/pub/scm/virt/kvm/qemu-kvm.git ?
>=20
> There have been a number of HPET emulation fixes.

Indeed, that works better.

johannes

--=-YXw8rfSehlFSUiEbgzh7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLCyFVAAoJEODzc/N7+QmazeIQALYPM5Y+hzZ1SurR3PIIwUyx
RLLCDirnqPyY+Gfel79YOLjKMgMDPu3MasiLHFTXVZsBK6OK6D1lL4hDy7boX+0L
R3NoQilg9n+sEBczRHa670W+w2InxdDHU32MU3nslvwPZZgCwszvFPv68PoWfj0Y
IvcKi51rOVUeWiLjk7EHfwYhnc2MSq4XJya721Ch3uxe4W7MAm7811PtxkMhPM1t
9jReQgmPp6NEMdHekc9Br9h1xJrOlYmIIrMBFr5w9mSAPn6hVsqjcsxfEuEwypM7
NYpCL1deT2fEau0MGRE6Q+iHuA8GoCSEMwbhFK2nyXePtA+HltWIt7nmUjNpPg/o
hpXZ+6nhvTSD16BiuWLOSOkDmscRVkK7LmVDkqEOWtvtNwScWXO4Z4srdfxsS0++
tIY5+aQXHxXZKzWrGjOwrocmv5QMTeMznoP5AXN6crDSmQvzkeD7HGYTX+YInDbZ
14n5JLsTkjf6BjSxVgeKcgfu/3ll3d3YJPBEQt6zB1jNYMRluDnVVjWLMVJpDA5o
ODmx01YAwslEf/T02VXiYfBZcc4cPp828iWxBEcUHZste87qehiNehJk0jSlsP7J
cFtrhjV547+KP63EfteevTtzfdnAg3fKkdou9Ex0SUJI9vbzTdrE9FYgfnLAkRlC
CkPGUM2Ji8HnYmPs2shg
=Lkkq
-----END PGP SIGNATURE-----

--=-YXw8rfSehlFSUiEbgzh7--

