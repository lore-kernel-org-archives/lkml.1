Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab0BVXUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 18:20:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948Ab0BVXUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 18:20:36 -0500
Message-ID: <4B83112D.30702@redhat.com>
Date: Mon, 22 Feb 2010 15:20:13 -0800
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
References: <20100222225320.20686.17645.stgit@localhost6.localdomain6> <20100222225354.20686.67443.stgit@localhost6.localdomain6> <4B830E6F.4020401@redhat.com> <4B830F82.70808@redhat.com> <4B8310D9.4080104@redhat.com>
In-Reply-To: <4B8310D9.4080104@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/22/2010 03:18 PM, Masami Hiramatsu wrote:
> Ah, would you mean 'j' prefix? like as 'printf("%jx", (uintmax_t)Addr);' ?

Yes, 'j' modifier works, too.

- -- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuDES0ACgkQ2ijCOnn/RHTZKwCcDRoezt14/15uKWGazHLRZGsb
JKMAniOCBgOOkafc7i1jSd+oCLuh7B9T
=lt3P
-----END PGP SIGNATURE-----
