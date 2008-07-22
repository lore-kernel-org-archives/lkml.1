Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbYGVOr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbYGVOr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbYGVOru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 10:47:50 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:45794 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbYGVOru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 10:47:50 -0400
Message-ID: <4885F299.4090300@novell.com>
Date: Tue, 22 Jul 2008 10:45:45 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Max Krasnyansky <maxk@qualcomm.com>, mingo@elte.hu,
       dmitry.adamushko@gmail.com, torvalds@linux-foundation.org, pj@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]	cpu	hotplug,	sched:Introduce	cpu_active_map	and	redoscheddomainmanagment
 (take	2)
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>	 <487DAD86.BA47.005A.0@novell.com> <487E6BD7.3020006@qualcomm.com>	 <487E7B6C.BA47.005A.0@novell.com> <487EF1E9.2040101@qualcomm.com>	 <487EFB71.BA47.005A.0@novell.com> <487F9509.9050802@qualcomm.com>	 <487F6972.BA47.005A.0@novell.com> <1216382024.28405.26.camel@twins>	 <488052D5.BA47.005A.0@novell.com> <48856BA9.6050609@qualcomm.com>	 <4885E952.8020708@novell.com> <1216736160.7257.97.camel@twins>	 <4885EC11.2050906@novell.com> <1216736764.7257.99.camel@twins>
In-Reply-To: <1216736764.7257.99.camel@twins>
X-Enigmail-Version: 0.95.6
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF2D8342CB82A5252D3D37873"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF2D8342CB82A5252D3D37873
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Peter Zijlstra wrote:
> On Tue, 2008-07-22 at 10:17 -0400, Gregory Haskins wrote:
>
>  =20
>> Thanks Peter.
>>
>> BTW: I should mention that this was just an RFC.  I haven't even build=
=20
>> tested it yet.  I will do this now.
>>    =20
>
> Heh, might make sense to ensure it indeed builds before stuffing it int=
o
> -tip ;-)
>
>  =20

Ok, it passes the sniff test without any corrections.  :)

Change the status from RFC to consider-for-inclusion.

-Greg


--------------enigF2D8342CB82A5252D3D37873
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkiF8pkACgkQlOSOBdgZUxn4nwCfaWhHKuM1TyoVSPEW474ur4sG
U/8An3LA6HyEiyQlH3vkbvzqGygN2jrA
=YPZ0
-----END PGP SIGNATURE-----

--------------enigF2D8342CB82A5252D3D37873--
