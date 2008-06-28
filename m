Return-Path: <linux-kernel-owner+w=401wt.eu-S1762521AbYF1Aa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762521AbYF1Aa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 20:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755510AbYF1AaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 20:30:21 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:58078 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbYF1AaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 20:30:19 -0400
Message-ID: <486585F3.7080906@kernel.org>
Date: Fri, 27 Jun 2008 17:29:39 -0700
From: Andrew Morgan <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 3/4] security: filesystem capabilities refactor kernel
 code
References: <48635823.2080002@kernel.org> <20080627210616.GC17415@us.ibm.com>
In-Reply-To: <20080627210616.GC17415@us.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Serge E. Hallyn wrote:
| Quoting Andrew G. Morgan (morgan@kernel.org):
| More optimal kernel locking for filesystem capability support.

~From 73bb5a039e95b9d150c74feaf5824a1f761fb718 Mon Sep 17 00:00:00 2001
From: Andrew G. Morgan <morgan@kernel.org>
Date: Wed, 25 Jun 2008 23:30:44 -0700
Subject: [PATCH] Refactor filesystem capability support in main kernel.

| No changelog, so I assume this is essentially the same patch as I
| acked+tested on Jun 23.

| Acked-by: Serge Hallyn <serue@us.ibm.com>

Yes. I just broke the original patch into 1/4 and 3/4. (2/4 and 4/4 are new)

| -serge

Thanks

Andrew
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIZYXx+bHCR3gb8jsRAjh7AKCc8hj+0e8v2ubb9wji94l0YKDamgCZAcsE
9WVJ1GGLWMOqQl4jl5LPexs=
=k/dq
-----END PGP SIGNATURE-----
