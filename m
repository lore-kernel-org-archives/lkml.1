Return-Path: <linux-kernel-owner+w=401wt.eu-S965639AbXFFXAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965639AbXFFXAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965280AbXFFW7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:59:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965038AbXFFW7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:59:54 -0400
Message-ID: <46673C24.4070808@redhat.com>
Date: Wed, 06 Jun 2007 15:58:44 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7> <20070606235906.72439d16@the-village.bc.nu>
In-Reply-To: <20070606235906.72439d16@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Alan Cox wrote:
> 	prctl(PR_SPARSEFD, 1);
> 
> to turn on sparse fd allocation for a process ?

Yes, there is.  Go back and read the archives.  It has been discussed in
depth.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGZzwk2ijCOnn/RHQRAtKGAKCTX5njQnYeyDn4XUGFAZ3Ojai+mwCeN/j0
jibBDSqQpXhR2CwIQNRAnXw=
=sJb0
-----END PGP SIGNATURE-----
