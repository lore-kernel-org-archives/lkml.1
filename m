Return-Path: <linux-kernel-owner+w=401wt.eu-S1752907AbZH1Tpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbZH1Tpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 15:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbZH1Tpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 15:45:42 -0400
Received: from mail-px0-f174.google.com ([209.85.216.174]:51864 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbZH1Tpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:45:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=bSZAOsegifdzH6Vyh9ddzWgETQyjeihpy4KEx4FAh7V/HS5uhr+D7PNJOlpJOY1dID
         KeSVf8UNu1fuEpPosEIE+zl915o+FZTftWWCW6eVxXv0FHyZ7N5nlQxtyYN0ARqHq14S
         U2h5c29y+ZiwndBH0UDUr/gtFcIaxncerQ3pc=
Message-ID: <4A9833DE.4030600@gmail.com>
Date: Fri, 28 Aug 2009 15:45:34 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: FTRACE: regression in 31-rc7
References: <4A96B55C.10001@gmail.com> <20090827164007.GA30679@elte.hu> <4A96BB40.1070306@gmail.com> <alpine.DEB.2.00.0908271301200.29943@gandalf.stny.rr.com> <4A96BD50.9040204@gmail.com> <alpine.DEB.2.00.0908271334230.19345@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0908271334230.19345@gandalf.stny.rr.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD0D2B45A00F08A7FBA5524FD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD0D2B45A00F08A7FBA5524FD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Steven Rostedt wrote:
> On Thu, 27 Aug 2009, Gregory Haskins wrote:
>=20
>> Hi Steve,
>>
>> Steven Rostedt wrote:
>> instrumented for some reason.
>>> Hmm, so you think something with the modules broke? I can test that o=
ut=20
>>> here.
>> Thats my (admittedly fairly ignorant) theory based on the limited data=

>> samples I have in front of me. :)
>>
>> If I get a chance later, I will try to do something more scientific, o=
r
>> at least a bisect.
>=20
> I just did this:

<snip>

I just did a clean build with -rc7 and all is well.  Not sure what
happened before, but sorry for the noise...

Kind Regards,
-Greg


--------------enigD0D2B45A00F08A7FBA5524FD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqYM94ACgkQP5K2CMvXmqHIOACbBZQE1MaULk5hTvRD+9jBSmLk
E/UAn2KdthUjO9AaMKY5HEraU45ko0Ka
=mbxx
-----END PGP SIGNATURE-----

--------------enigD0D2B45A00F08A7FBA5524FD--
