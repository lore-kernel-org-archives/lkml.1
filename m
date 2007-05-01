Return-Path: <linux-kernel-owner+w=401wt.eu-S1030755AbXEAMqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030755AbXEAMqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 08:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030777AbXEAMqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 08:46:53 -0400
Received: from h80ad26a9.async.vt.edu ([128.173.38.169]:37376 "EHLO
	h80ad26a9.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030755AbXEAMqx (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 08:46:53 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mockern@yandex.ru
Cc: linux-kernel@vger.kernel.org
Subject: Re: makefile question
In-Reply-To: Your message of "Tue, 01 May 2007 16:38:22 +0400."
             <463734BE.000004.23425@webmail15.yandex.ru>
From: Valdis.Kletnieks@vt.edu
References: <463734BE.000004.23425@webmail15.yandex.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1178023611_28512P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 01 May 2007 08:46:51 -0400
Message-ID: <16346.1178023611@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1178023611_28512P
Content-Type: text/plain; charset=us-ascii

On Tue, 01 May 2007 16:38:22 +0400, Mockern said:

> I have 4 idedntical  drivers, there are only 2 differences: major and minor
> numbers of each driver.

That's the *only* difference?  You don't have different major/minor pairs that
correspond to different PCI IDs, or something?  I'm confused as to what you're
trying to achieve here - if the problem is that /dev/mydev0 through /dev/mydev3
have different major/minors on different systems, there's probably eaiser ways
to fix that in userspace...


--==_Exmh_1178023611_28512P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGNza7cC3lWbTT17ARApgHAJ9B8xQk7RdxKOxXiJDggFC8jpPUpgCgvlEQ
4ZQkmCBmOV438UShxSrTTY4=
=9tv/
-----END PGP SIGNATURE-----

--==_Exmh_1178023611_28512P--
