Return-Path: <linux-kernel-owner+w=401wt.eu-S967335AbXFHC5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967335AbXFHC5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 22:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966746AbXFHC5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 22:57:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966688AbXFHC5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 22:57:03 -0400
Message-ID: <4668C538.9090006@redhat.com>
Date: Thu, 07 Jun 2007 19:55:52 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>	<20070606235906.72439d16@the-village.bc.nu>	<Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>	<20070607001932.35c9591c@the-village.bc.nu>	<466741BD.20106@redhat.com>	<20070607110432.73be7960@the-village.bc.nu>	<4668155B.4020705@redhat.com>	<20070607195659.c695c87d.dada1@cosmosbay.com>	<46684DED.6000907@redhat.com>	<Pine.LNX.4.64.0706071132130.6445@alien.or.mcafeemobile.com> <20070607130319.8fd96e03.akpm@linux-foundation.org>
In-Reply-To: <20070607130319.8fd96e03.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> Absolutely.  Let's get them into their final form now, rather than letting
> some intermediate interface escape out into a major kernel release.

Even if Linus' redirection is adopted, these interfaces should still be
fixed up.  No need to rely on hacks if we can still fix up the interfaces.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGaMU42ijCOnn/RHQRAm0MAJ9pprTVUD/2YvDsL6CPL21WvZSkEACeN3r8
TT8a5FyF2rCct+8gBKyWF/s=
=fs4f
-----END PGP SIGNATURE-----
