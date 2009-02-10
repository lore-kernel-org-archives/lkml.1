Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbZBJDqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbZBJDqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 22:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZBJDqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 22:46:12 -0500
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:52499 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbZBJDqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 22:46:12 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Feb 2009 22:46:12 EST
From: Frank Mori Hess <fmhess@speakeasy.net>
Reply-To: fmhess@users.sourceforge.net
To: Shawn Bohrer <shawn.bohrer@ni.com>
Subject: Re: [staging] High level Comedi feedback
Date: Mon, 9 Feb 2009 22:38:44 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, abbotti@mev.co.uk,
       ds@schleef.org
References: <20090209180144.GD18058@bohrers.amer.corp.natinst.com>
In-Reply-To: <20090209180144.GD18058@bohrers.amer.corp.natinst.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1325374.vydHzUg8db";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200902092238.49109.fmhess@speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1325374.vydHzUg8db
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 09 February 2009 13:01, Shawn Bohrer wrote:
> 6. COMEDI doesn't yet support configuring hardware buffer sizes for deep
> on-board FIFOs.

There is INSN_CONFIG_BLOCK_SIZE, which a couple drivers use to configure=20
their hardware fifo size.

By the way, I'm not subscribed to linux-kernel.  Comedi does have its own=20
mailing list, maybe this kind of discussion would be easier on a more=20
specific, lower traffic list?

--nextPart1325374.vydHzUg8db
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBJkPbJ5vihyNWuA4URAqmaAJ9YzOjWAg449sCbfcw2I5FIC8aHCQCfUuY0
z4yLPymuuYl1I1y5UsCl4pM=
=1p2p
-----END PGP SIGNATURE-----

--nextPart1325374.vydHzUg8db--
