Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbYEEFFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbYEEFFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 01:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYEEFFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 01:05:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbYEEFFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 01:05:32 -0400
Message-ID: <481E94EE.2060800@redhat.com>
Date: Sun, 04 May 2008 22:02:38 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mtk.manpages@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 01/18] flag parameters: helper function
References: <200805050342.m453gkY4029814@devserv.devel.redhat.com> <Pine.LNX.4.64.0805042144320.8307@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0805042144320.8307@alien.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Davide Libenzi wrote:
> I dunno if this deserves separate c/h files. Otherwise ...

I used separate files because all of the users are in optional code.  I
would have had to stuff the code in a completely unrelated file which I
think isn't clean.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkgelO4ACgkQ2ijCOnn/RHSVQgCffwvlbMeZTI5N19+J13VS8+ng
8/0AoI8wwTtrAwbFIbuu9e4RrvEIzWGC
=2gim
-----END PGP SIGNATURE-----
