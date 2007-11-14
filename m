Return-Path: <linux-kernel-owner+w=401wt.eu-S1763444AbXKNFN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763444AbXKNFN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 00:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758478AbXKNFNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 00:13:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757110AbXKNFNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 00:13:05 -0500
Message-ID: <473A832C.5040906@redhat.com>
Date: Tue, 13 Nov 2007 21:10:04 -0800
From: Ulrich Drepper <drepper@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: 2.6.24-rc2-mm1
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>	<473A6E72.60503@googlemail.com> <20071113205544.2a7743b4.akpm@linux-foundation.org>
In-Reply-To: <20071113205544.2a7743b4.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> Oh well.  That's CLONE_DETACHED and I think Ulrich's question just got
> answered.
> 
> Which distro/version are you running?

People should really compile their glibc better than this.  The sources
still use it but only if you compile for compatibility with kernels
before 2.6.2.  Nobody should need to need such backward compatibility.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFHOoMs2ijCOnn/RHQRAn+rAJ91vQoJRpuyPJipNLFn+3g6bajDtwCgs9fm
moefStvq8QdvOxVLLDPUC1o=
=GsVU
-----END PGP SIGNATURE-----
