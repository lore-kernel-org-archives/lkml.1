Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbXEFGt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbXEFGt4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 02:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbXEFGt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 02:49:56 -0400
Received: from h80ad2754.async.vt.edu ([128.173.39.84]:46851 "EHLO
	h80ad2754.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbXEFGtz (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 02:49:55 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm1
In-Reply-To: Your message of "Sat, 05 May 2007 01:49:55 PDT."
             <20070505014955.8f3990b5.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1178434189_3690P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 06 May 2007 02:49:49 -0400
Message-ID: <17296.1178434189@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1178434189_3690P
Content-Type: text/plain; charset=us-ascii

On Sat, 05 May 2007 01:49:55 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/

  MODPOST vmlinux
WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text between 'kmem_cache_create' (at offset 0x20dff) and 'cache_reap'
WARNING: mm/built-in.o - Section mismatch: reference to .init.text: from .text between 'kmem_cache_create' (at offset 0x20e41) and 'cache_reap'

Built with CONFIG_SLAB, CONFIG_SMP, x86_64.

--==_Exmh_1178434189_3690P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGPXqNcC3lWbTT17ARAonMAKC1y/XedwYG635QCzNLfrnkqNHgFgCfXTpq
cu09QeWp4ljpqQD8pazQh9M=
=SHxn
-----END PGP SIGNATURE-----

--==_Exmh_1178434189_3690P--
