Return-Path: <linux-kernel-owner+w=401wt.eu-S932897AbXKOUZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897AbXKOUZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932173AbXKOUZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:25:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157AbXKOUZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:25:07 -0500
Message-ID: <473CA926.3080204@redhat.com>
Date: Thu, 15 Nov 2007 12:16:38 -0800
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederik Deweerdt <deweerdt@free.fr>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCHv2 2/4] x86&x86-64 support for sys_indirect
References: <200711151822.lAFIMVvW028590@devserv.devel.redhat.com> <20071115192947.GF1299@slug> <473CA729.5010906@redhat.com> <20071115201226.GA25641@elte.hu>
In-Reply-To: <20071115201226.GA25641@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ingo Molnar wrote:
> weird - i built it on 32-bit and it should have failed the build?

Not weird, since I've changed that file after Linus' comment.  The
mistake I made was to reuse the old 0/0 mail with your s-o-b line
without asking you again.  Sorry.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFHPKkm2ijCOnn/RHQRAkY2AKCRfOhk5pUrYuTSMWnBBgu0Ou0fJACfQVz1
qzhRYyWgS1xGQwI2eoHHTgc=
=DkS8
-----END PGP SIGNATURE-----
