Return-Path: <linux-kernel-owner+w=401wt.eu-S1760002AbYEAGMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002AbYEAGMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 02:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758408AbYEAGMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 02:12:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597AbYEAGML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 02:12:11 -0400
Message-ID: <48195E69.3030701@redhat.com>
Date: Wed, 30 Apr 2008 23:08:41 -0700
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: bsn.0007@gmail.com
CC: libc-alpha@sourceware.org, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Christoph Hellwig <hch@lst.de>, Mingming Cao <cmm@us.ibm.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       bharata@linux.vnet.ibm.com, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 1/2] Union Mount: glibc readdir support
References: <20080429133201.GA9938@localhost.localdomain> <20080429133346.GB9938@localhost.localdomain>
In-Reply-To: <20080429133346.GB9938@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Before anything further is discussed I need to know how you expect to
handle NFS?  I don't see how, with a userlevel readdir implementation,
you can support NFS.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkgZXmkACgkQ2ijCOnn/RHSFfwCgj/8c4C267owRAcKw//OF7z5E
kgkAn0chMraZqjmzFcWsQVgN4l4ZrD/X
=VXir
-----END PGP SIGNATURE-----
