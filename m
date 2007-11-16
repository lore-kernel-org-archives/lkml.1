Return-Path: <linux-kernel-owner+w=401wt.eu-S1759032AbXKPDQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032AbXKPDQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 22:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbXKPDQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 22:16:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483AbXKPDQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 22:16:23 -0500
Message-ID: <473D0B55.6090400@redhat.com>
Date: Thu, 15 Nov 2007 19:15:33 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv2 2/4] x86&x86-64 support for sys_indirect
References: <200711151822.lAFIMVvW028590@devserv.devel.redhat.com> <473D04DA.9060305@cosmosbay.com>
In-Reply-To: <473D04DA.9060305@cosmosbay.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Eric Dumazet wrote:
> I am not sure how compat is handled ? (ie running a 32bit task in a
> 64bit kernel)

I already mentioned that I have a patch here.  I'll test it first, though.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHPQtU2ijCOnn/RHQRAqRYAKCA6x79xzmYxS0WjdoB29+1bIcP4gCgpAj3
VmOkji7I1Ec+FaMeLSf1fSA=
=7jn7
-----END PGP SIGNATURE-----
