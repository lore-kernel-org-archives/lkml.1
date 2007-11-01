Return-Path: <linux-kernel-owner+w=401wt.eu-S1761358AbXKAO52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761358AbXKAO52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbXKAO5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:57:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047AbXKAO5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:57:18 -0400
Message-ID: <4729E936.4040400@redhat.com>
Date: Thu, 01 Nov 2007 07:56:54 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] PID namespace design bug, workaround
References: <20071101144307.GA29566@elte.hu> <4729E7E4.8070208@openvz.org>
In-Reply-To: <4729E7E4.8070208@openvz.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Pavel Emelyanov wrote:
> With this set we'll be able to mark pid namespaces as EXPERIMENTAL
> or even BROKEN, so nobody will be able to crate them. So can we, please, 
> keep things as they are for now - the appropriate fix will be ready 
> soon.

You sound far too optimistic for my taste.  I probably haven't seen the
proposal you have in mind but everything else I have seen simply doesn't
work without breaking something.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHKek22ijCOnn/RHQRAgJIAJ0VYwYHUKdEcnKfZHDdaUr5HTnk9QCgghTH
n57LDahLDIIVIIlkrwNVLLQ=
=2xU8
-----END PGP SIGNATURE-----
