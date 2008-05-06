Return-Path: <linux-kernel-owner+w=401wt.eu-S1759902AbYEFCeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902AbYEFCeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 22:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYEFCeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 22:34:02 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36460 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbYEFCeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 22:34:01 -0400
Message-ID: <481FC38A.6070805@redhat.com>
Date: Mon, 05 May 2008 19:33:46 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 02/18] flag parameters: socket and socketpair
References: <200805050342.m453gktl029817@devserv.devel.redhat.com> <20080505185850.789d870a.akpm@linux-foundation.org>
In-Reply-To: <20080505185850.789d870a.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> afaict we only ever remap one or two flags.

So far.  I have plans for at least one more flag: the one we'll
hopefully have sometime soon to request non-sequential file descriptors.
 There is no reason why there shouldn't be even more in future.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIH8OK2ijCOnn/RHQRAgd/AJ47rSUE8UZotXuce4mp6SMWn08OQACdH8tS
kcd8c40jXlDlE1LySSdf5mQ=
=7KVe
-----END PGP SIGNATURE-----
