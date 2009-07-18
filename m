Return-Path: <linux-kernel-owner+w=401wt.eu-S1751714AbZGRMls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbZGRMls (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 08:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbZGRMlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 08:41:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54578 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZGRMlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 08:41:45 -0400
Message-ID: <4A61C2E6.1030507@redhat.com>
Date: Sat, 18 Jul 2009 05:41:10 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Zhaolei <zhaolei@cn.fujitsu.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Add function to convert between calendar time and
 broken-down time for universal use
References: <4A5C3BC0.6020701@cn.fujitsu.com> <20090718100050.GB24164@elte.hu>
In-Reply-To: <20090718100050.GB24164@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ingo Molnar wrote:
> I'm also wondering whether including LGPL glibc code in the kernel 
> like this is license-appropriate

You can declare the modified code GPLed, no problem.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkphwuUACgkQ2ijCOnn/RHTUFACcD0BZA8AakHERAjnkFOAbYDE0
A7YAnRUrer6z+mRmwXgBBT3/jMUGDBV9
=t0FC
-----END PGP SIGNATURE-----
