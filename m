Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbYHKRSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbYHKRSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 13:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYHKRR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 13:17:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbYHKRR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 13:17:57 -0400
Message-ID: <48A0741F.60901@redhat.com>
Date: Mon, 11 Aug 2008 10:17:19 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Dario Faggioli <raistlin@linux.it>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [RFC 0/1][PATCH] POSIX SCHED_SPORADIC implementation for tasks
 and groups
References: <1218462574.6450.24.camel@Palanthas>	 <48A0487B.7080600@redhat.com>  <1218464753.10800.92.camel@twins>	 <1218471794.6450.87.camel@Palanthas> <1218472252.10800.107.camel@twins>
In-Reply-To: <1218472252.10800.107.camel@twins>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Peter Zijlstra wrote:
> Well, a new version of glibc could use those to implement the posix
> interface. Because as I understand it, glibc can break ABI on certain
> version bumps.

In theory.  But this hasn't happened so far and I don't expect it to
happen any time soon.  New interfaces are not a real problem for me, though.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkigdB8ACgkQ2ijCOnn/RHSQSQCfaDp3XAM9vJXHBIqSM7PQq1n2
AwkAoMmMyglHDYe4aw2Yqa6jQgG/48er
=D9Eb
-----END PGP SIGNATURE-----
