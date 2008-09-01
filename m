Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbYIASAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbYIASAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 14:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbYIASA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 14:00:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50619 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYIASAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 14:00:25 -0400
Message-ID: <48BC2D55.6080906@redhat.com>
Date: Mon, 01 Sep 2008 10:58:45 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] make setpriority POSIX compliant; introduce	PRIO_THREAD
 extension
References: <1220278355.3866.21.camel@localhost.localdomain>	 <1220280138.3866.31.camel@localhost.localdomain> <1220281737.8426.67.camel@twins>
In-Reply-To: <1220281737.8426.67.camel@twins>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Peter Zijlstra wrote:
> Also, I guess the glibc people (Ulrich added to CC) might have an
> opinion.

Looks good.

I just wish we could get something similar for setuid and friends.
Perhaps after David cred patches?

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAki8LVUACgkQ2ijCOnn/RHTWYQCePQKadvZWkC8ZoH+DOHd/N+et
KwAAoKxASCCigXbO67/rSwggRIkemPKw
=MixL
-----END PGP SIGNATURE-----
