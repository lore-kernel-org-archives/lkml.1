Return-Path: <linux-kernel-owner+w=401wt.eu-S1761618AbXEaScr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761618AbXEaScr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbXEaSch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:32:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761486AbXEaScf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:32:35 -0400
Message-ID: <465F14AF.3020908@redhat.com>
Date: Thu, 31 May 2007 11:32:15 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Nicholas Miell <nmiell@comcast.net>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] Introduce O_CLOEXEC (take >2)
References: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com> <1180635728.3104.3.camel@entropy>
In-Reply-To: <1180635728.3104.3.camel@entropy>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Nicholas Miell wrote:
> O_CLOSEONEXEC, perhaps?

Then nobody would know this is equivalent to FD_CLOEXEC.  I think the
name I propose is fine.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGXxSv2ijCOnn/RHQRAhELAJ9/7pTQeZShV6NDfEx+iVSfD5g02gCeM/y+
E0GvuEg2EBtOmDdI5MEzOG0=
=W6hQ
-----END PGP SIGNATURE-----
