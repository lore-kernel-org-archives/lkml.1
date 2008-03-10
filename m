Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbYCJEe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbYCJEe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 00:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYCJEeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 00:34:50 -0400
Received: from tuxrocks.com ([208.78.103.217]:41148 "EHLO tuxrocks.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbYCJEet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 00:34:49 -0400
Message-ID: <47D4BA48.4080107@tuxrocks.com>
Date: Sun, 09 Mar 2008 23:34:16 -0500
From: Frank Sorenson <frank@tuxrocks.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc4-git3: Reported regressions from 2.6.24
References: <200803100132.57160.rjw@sisk.pl>
In-Reply-To: <200803100132.57160.rjw@sisk.pl>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Rafael J. Wysocki wrote:
> [Due to the lack of time for reviewing all of the email threads related to the
> regressions marked as "unresolved" below, I might have missed some patches
> fixing them.  If you are involved in debugging/fixing any of them, please let
> me know if I should update the list.  Thanks!]
> 
> This message contains a list of some regressions from 2.6.24 reported since
> 2.6.25-rc1 was released, for which there are no fixes in the mainline I know
> of.  If any of them have been fixed already, please let me know.
> 
> If you know of any other unresolved regressions from 2.6.24, please let me know
> either and I'll add them to the list.  Also, please let me know if any of the
> entries below are invalid.


> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10187
> Subject		: 2.6.25-rc4 OOMs itself dead on bootup
> Submitter	: Frank Sorenson <frank@tuxrocks.com>
> Date		: 2008-03-06 17:26
> References	: http://marc.info/?l=linux-kernel&amp;m=120482709209046&amp;w=2
> Handled-By	: Ingo Molnar <mingo@elte.hu>
> Patch		: http://lkml.org/lkml/2008/3/8/15

Not a regression, and the patch is not required.  The OOM was caused by
something specific to my system, and it's been resolved.

Frank
- --
Frank Sorenson - KD7TZK
Linux Systems Engineer, DSS Engineering, UBS AG
frank@tuxrocks.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFH1LpFaI0dwg4A47wRAojeAKCdZVriUHycsWCTkvgxnHS8jSopAwCfX9qP
gHgqRtuLjFgzE4liNFZtf2o=
=PTNr
-----END PGP SIGNATURE-----
