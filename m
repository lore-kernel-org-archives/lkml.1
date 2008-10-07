Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbYJGBwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbYJGBwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbYJGBwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 21:52:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53427 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbYJGBwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 21:52:14 -0400
Message-ID: <48EAC090.3000401@redhat.com>
Date: Mon, 06 Oct 2008 18:51:12 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: Roland McGrath <roland@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Jakub Jelinek <jakub@redhat.com>,
       libc-alpha@sourceware.org
Subject: Re: [PATCH] ELF: implement AT_RANDOM for future glibc use
References: <20081001220948.GC32107@sunsite.ms.mff.cuni.cz> <20081001222706.68E7E1544B4@magilla.localdomain> <20081003001616.GN10632@outflux.net> <87ej2untze.fsf@basil.nowhere.org> <20081006175038.GF10357@outflux.net> <20081006192641.GI3180@one.firstfloor.org> <20081006220759.GM10357@outflux.net> <20081006235827.59306154271@magilla.localdomain> <20081007003119.GS10357@outflux.net> <48EAB40C.5010607@redhat.com> <20081007014429.GU10357@outflux.net>
In-Reply-To: <20081007014429.GU10357@outflux.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Kees Cook wrote:
> is the following good enough for now for glibc:

No, definitely not.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkjqwJAACgkQ2ijCOnn/RHTyPgCeNxmD/YZviECSPkUfLVwOvzWR
baEAnj+DAloWyH8LK5Hb4d5E/rQfVgGJ
=zJ5z
-----END PGP SIGNATURE-----
