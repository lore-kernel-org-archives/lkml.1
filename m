Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbZHULfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbZHULfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 07:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbZHULfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 07:35:23 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:9716 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbZHULfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 07:35:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=T6QwYD1ajINx6ajMCgb7tOO/CasgyspvoeY1gz1M9NGa5eTUt808cYECeAh8gtsyhV
         PJKy5DSIX5kLRqW35lSIk65hOHn6Jx71LIowq8ySueCcWsAtvvypVkrPKa/RvQJ6tKXz
         PDavVmzRodB0awal4s97Vyr18cyGnoQqTmRLA=
Message-ID: <4A8E8675.1070100@gmail.com>
Date: Fri, 21 Aug 2009 07:35:17 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Kyle McMartin <kyle@mcmartin.ca>, "Carlos R. Mafra" <crmafra@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: perf: Problem compiling /tools/perf/Documentation in 2.6.31-rc6
References: <4A8D9D56.5080107@gmail.com> <20090820221528.GS25206@bombadil.infradead.org> <20090821113134.GB24647@elte.hu>
In-Reply-To: <20090821113134.GB24647@elte.hu>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4A6E6BA5C9A86BA277B27193"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4A6E6BA5C9A86BA277B27193
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> * Kyle McMartin <kyle@mcmartin.ca> wrote:
>=20
>> On Thu, Aug 20, 2009 at 03:00:38PM -0400, Gregory Haskins wrote:
>>> Hi Ingo,
>>>
>>> I'm seeing this in 2.6.31-rc6:
>>>
>>> ghaskins@dev:~/sandbox/git/fabric/linux-2.6/tools/perf/Documentation>=
 make
>>>     SUBDIR ../
>>> make[1]: `PERF-VERSION-FILE' is up to date.
>>>     ASCIIDOC perf-examples.html
>>> ERROR: perf-examples.txt: line 1: manpage document title is mandatory=

>>> FAILED: perf-examples.txt: line 8: illegal style name: From an e-mail=
 by
>>> Ingo Molnar
>>> make: *** [perf-examples.html] Error 1
>>>
>>> It could very well be pilot error.  Any ideas?
>>>
>> This was fixed in a recent commit to tip, probably upstream by now.
>> http://git.kernel.org/?p=3Dlinux/kernel/git/x86/linux-2.6-tip.git;a=3D=
commitdiff;h=3D2932cffc89e9a1476b28a59896fa4f81e0d4f131
>=20
> Yeah, the fix is upstream now, Linus pulled it two days ago.
>=20
> 	Ingo

Thanks all,

-Greg


--------------enig4A6E6BA5C9A86BA277B27193
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkqOhnUACgkQP5K2CMvXmqEGsACfVZS7emajJG/mRDhLi2nrEJMV
ZAkAn25NVK/UhzkSZjWU95o9HhDEEbWO
=I9AJ
-----END PGP SIGNATURE-----

--------------enig4A6E6BA5C9A86BA277B27193--
