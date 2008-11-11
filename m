Return-Path: <linux-kernel-owner+w=401wt.eu-S1751603AbYKKSrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbYKKSrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 13:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbYKKSrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 13:47:16 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:40835 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbYKKSrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 13:47:15 -0500
Message-ID: <4919D417.5020500@novell.com>
Date: Tue, 11 Nov 2008 13:51:03 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: rostedt@goodmis.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [RFC PATCH 0/3] Series short description
References: <20081111142323.28477.41235.stgit@dev.haskins.net> <20081111175649.GA12339@elte.hu>
In-Reply-To: <20081111175649.GA12339@elte.hu>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6F1C85D8458E34C041DB35E9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6F1C85D8458E34C041DB35E9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> * Gregory Haskins <ghaskins@novell.com> wrote:
>
>  =20
>> Hi Ingo, Steven, Peter,
>>   This series applies roughly to mainline as an enhancement to the sch=
ed_rt
>>   logic.  Peter and I were discussing some of the unecessary overhead =
in
>>   pull_rt_tasks() via IRC, and this is my RFC attempt to address the p=
roblem.
>>
>>   I have built/booted this on a 4-way C2D Xeon box and it passes preem=
pt-test.
>>
>>   Comments, please.
>>    =20
>
> this direction looks very nifty to me. Peter, do you Ack them?
>
> 	Ingo
>  =20
[I just noticed that I fat-fingered the -rt list address, so here is a
link to the thread for those subscribed to -rt]

http://lkml.org/lkml/2008/11/11/193

-Greg


--------------enig6F1C85D8458E34C041DB35E9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkkZ1BcACgkQlOSOBdgZUxnr1gCdESRbOlYbwhQfvGy3/SU/G7p0
6iwAn0UB67EZYd1/06XdiTWeJxa/Tc3S
=vfKT
-----END PGP SIGNATURE-----

--------------enig6F1C85D8458E34C041DB35E9--
