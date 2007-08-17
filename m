Return-Path: <linux-kernel-owner+w=401wt.eu-S1759135AbXHQHjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135AbXHQHjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 03:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbXHQHjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 03:39:01 -0400
Received: from styx.suse.cz ([82.119.242.94]:38083 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753496AbXHQHjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 03:39:00 -0400
Message-ID: <46C5514C.4010605@suse.cz>
Date: Fri, 17 Aug 2007 09:42:04 +0200
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE CR, s.r.o.
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
Cc: anandjigar@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Fork Bombing Patch
References: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>	<1187250004.12446.3.camel@elijah.suse.cz> <20070817001954.38010df3.pj@sgi.com>
In-Reply-To: <20070817001954.38010df3.pj@sgi.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Paul Jackson wrote:
> Petr wrote:
>> Please do not add comments inside functions.
> 
> I find this advice a bit odd.  I am not aware of
> any prohibition of comments inside functions.
> 
> As with comments outside functions, they should
> serve a worthwhile purpose, of course.  One might
> debate whether this particular comment added by
> Anand was sufficiently valuable to be worth
> having.
> 
> But I don't agree to a blanket prohibition on
> comments inside functions.

I'm not saying that comments inside functions should be prohibited, but
comments inside functions often lead to over-commenting. There must be a
good reason for adding such a comment. See CodingStyle, chapter 8:
Commenting:

Also, try to avoid putting comments inside a function body.

(Before somebody starts arguing with this one sentence, please also read
the rest of the chapter; it is not long and you'll understand the
author's intention better.)

Kind regards,
Petr Tesarik
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGxVFLjpY2ODFi2ogRAoLUAJwI+cywi9iKHWlx4yora0+WJfCEawCglyrf
xyucPIB3W63sbM1dw/Nsv2Y=
=SL8f
-----END PGP SIGNATURE-----
