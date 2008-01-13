Return-Path: <linux-kernel-owner+w=401wt.eu-S1751796AbYAMJgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbYAMJgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 04:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbYAMJgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 04:36:06 -0500
Received: from smtp10.unit.tiscali.de ([213.205.33.46]:38263 "EHLO
	smtp10.unit.tiscali.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbYAMJgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 04:36:05 -0500
X-Greylist: delayed 1254 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jan 2008 04:36:04 EST
From: Michael Gerdau <mgerdau@tiscali.de>
To: Abhishek Rai <abhishekrai@google.com>
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.23.13]
Date: Sun, 13 Jan 2008 10:14:40 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, rohitseth@google.com,
       akpm@linux-foundation.org, phillips@phunq.net
References: <Pine.LNX.4.64.0801130026480.4286@vmfs7.nyc.corp.google.com>
In-Reply-To: <Pine.LNX.4.64.0801130026480.4286@vmfs7.nyc.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1353550.V3LuEa6ubV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801131015.02683.mgerdau@tiscali.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1353550.V3LuEa6ubV
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

This patch does not apply to a clean 2.6.23.13 tree using either of
  patch -p1 <patch.ext3-fsck-faster
  patch -p1 -l <patch.ext3-fsck-faster

Best,
Michael
=2D-=20
 Michael Gerdau       email: mgerdau@tiscali.de
 GPG-keys available on request or at public keyserver

--nextPart1353550.V3LuEa6ubV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHidaWUYYhyuxDQc4RAo72AJ9fsKLin6jIsdWFonwStcrekrbwIwCghdV9
Kw239CV0zxyK7CbbDYXa0h8=
=bZxy
-----END PGP SIGNATURE-----

--nextPart1353550.V3LuEa6ubV--
