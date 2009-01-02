Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbZABEcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbZABEcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 23:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbZABEcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 23:32:39 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:46573 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbZABEcj (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 23:32:39 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: g3vbv@blueyonder.co.uk
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-git forcedeth dead interface and nvidia problems
In-Reply-To: Your message of "Thu, 01 Jan 2009 04:55:28 GMT."
             <495C4CC0.1040006@blueyonder.co.uk>
From: Valdis.Kletnieks@vt.edu
References: <495C4CC0.1040006@blueyonder.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1230870755_3311P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 01 Jan 2009 23:32:35 -0500
Message-ID: <40555.1230870755@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1230870755_3311P
Content-Type: text/plain; charset=us-ascii

On Thu, 01 Jan 2009 04:55:28 GMT, Sid Boyce said:

> The NVidia driver 180.18 works fine with 2.6.28, but fails with
> 2.6.28-git. The module builds and installs fine, Xorg.0.log says:-
> (II) NVIDIA(0): Initialized GPU GART.
> (II) NVIDIA(0): Setting mode "1280x1024"
> (EE) NVIDIA(0): Failed to allocate video memory
> (EE) NVIDIA(0):  *** Aborting ***
> 
> Fatal server error:
> AddScreen/ScreenInit failed for driver 0

A posting on the NVidia forums indicates that booting with 'nopat' or
building a kernel with CONFIG_X86_PAT=n works.

--==_Exmh_1230870755_3311P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJXZjjcC3lWbTT17ARAtIxAKDNwwvkC7tnu4BlUdJMNujfj7PT8wCg5IYZ
kzCiBSmSSTV0TEbV/tnT344=
=tL0H
-----END PGP SIGNATURE-----

--==_Exmh_1230870755_3311P--
