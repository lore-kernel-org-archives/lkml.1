Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbZJZTrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbZJZTrr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbZJZTrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:47:45 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:46243 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbZJZTro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:47:44 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Gene Heskett <gene.heskett@verizon.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SHMEM question
In-Reply-To: Your message of "Mon, 26 Oct 2009 11:59:04 EDT."
             <200910261159.04995.gene.heskett@verizon.net>
From: Valdis.Kletnieks@vt.edu
References: <200910261159.04995.gene.heskett@verizon.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1256586467_3115P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 26 Oct 2009 15:47:47 -0400
Message-ID: <19654.1256586467@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4AE5FCE4.00F8,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1256586467_3115P
Content-Type: text/plain; charset=us-ascii

On Mon, 26 Oct 2009 11:59:04 EDT, Gene Heskett said:

> -r-------- 1 root root 67108904 2009-10-24 00:28 pulse-shm-3880918577

> That pulse-shm-3880918577 file at over 67 megabytes is all $00 till $04000000 
> into it, then there is 6 non-zero bytes and the rest is back to all balls.
> 
> Is this some indicator of a new rootkit or WTF?

No, it's pulseaudio.  It uses shared mem to move audio data between client
programs and the pulseaudio server.

--==_Exmh_1256586467_3115P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK5fzjcC3lWbTT17ARAjzkAKDWb5KF3NelgZePBx4UMya1jBvACwCguikU
J6vEVP0S+LL8Vo2UGzRiSCI=
=zuzt
-----END PGP SIGNATURE-----

--==_Exmh_1256586467_3115P--

