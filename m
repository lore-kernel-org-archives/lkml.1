Return-Path: <linux-kernel-owner+w=401wt.eu-S1751123AbZH0RHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123AbZH0RHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbZH0RHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:07:32 -0400
Received: from mail-px0-f174.google.com ([209.85.216.174]:59763 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZH0RHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:07:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=UlIymf/UD5snJD6GVW4yluSwdED/e6lnmOUAS665VtUPBMcRSr0DuIG6ME9yku5ljI
         bCXu5kp9QuP6VDIBTbpXUFFkZgtVtdvAZzJdRh2OiSWlsfBoBwthWc5rSY+IxSDGkpDM
         TTT5qnuzBCtnAWaEWs4P8EGeCvUbQMYMVq1nc=
Message-ID: <4A96BD50.9040204@gmail.com>
Date: Thu, 27 Aug 2009 13:07:28 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE: regression in 31-rc7
References: <4A96B55C.10001@gmail.com> <20090827164007.GA30679@elte.hu> <4A96BB40.1070306@gmail.com> <alpine.DEB.2.00.0908271301200.29943@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0908271301200.29943@gandalf.stny.rr.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7A47D61FCFE56FC20A624F98"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7A47D61FCFE56FC20A624F98
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Steve,

Steven Rostedt wrote:
instrumented for some reason.
>=20
> Hmm, so you think something with the modules broke? I can test that out=
=20
> here.

Thats my (admittedly fairly ignorant) theory based on the limited data
samples I have in front of me. :)

If I get a chance later, I will try to do something more scientific, or
at least a bisect.

Kind Regards,
-Greg


--------------enig7A47D61FCFE56FC20A624F98
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqWvVAACgkQP5K2CMvXmqEFLwCcC+rnqztJaWQRLpcDYZbbAc1c
8XcAn2Q7dcdqtMSeCPlYPtIIW/YtJsHR
=Uomu
-----END PGP SIGNATURE-----

--------------enig7A47D61FCFE56FC20A624F98--
