Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab0BVXTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 18:19:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089Ab0BVXTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 18:19:31 -0500
Message-ID: <4B8310E2.30609@redhat.com>
Date: Mon, 22 Feb 2010 15:18:58 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH -tip v2 5/9] perf probe: Use elfutils-libdw for analyzing
 debuginfo
References: <20100222225320.20686.17645.stgit@localhost6.localdomain6> <20100222225354.20686.67443.stgit@localhost6.localdomain6> <4B830E6F.4020401@redhat.com> <4B830F82.70808@redhat.com>
In-Reply-To: <4B830F82.70808@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/22/2010 03:13 PM, Masami Hiramatsu wrote:
> Hmm, I'm not sure about that. Could you point somewhere I can refer that?

That's C99 functionality:

  printf("The number is " PRIdMAX "\n", (intmax_t) var)

- -- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuDEOIACgkQ2ijCOnn/RHSvUgCfVUIcA3uQ7XwAyI1k1Yz0UAyA
wfQAn31OB1ewUz9+dBPJecfELq214Nq4
=dR9S
-----END PGP SIGNATURE-----
