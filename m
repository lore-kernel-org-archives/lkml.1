Return-Path: <linux-kernel-owner+w=401wt.eu-S964840AbXBLK2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964840AbXBLK2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 05:28:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964846AbXBLK2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 05:28:53 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:42583 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964840AbXBLK2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 05:28:52 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-scsi@vger.kernel.org
Subject: Re: [GIT PATCH] SCSI updates for 2.6.20
Date: Mon, 12 Feb 2007 11:29:28 +0100
User-Agent: KMail/1.9.6
Cc: James Bottomley <James.Bottomley@steeleye.com>,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1171166252.3373.58.camel@mulgrave.il.steeleye.com>
In-Reply-To: <1171166252.3373.58.camel@mulgrave.il.steeleye.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6168428.fcT4MqvegJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702121129.34359.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6168428.fcT4MqvegJ
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Am Sonntag, 11. Februar 2007 schrieb James Bottomley:
> This is the accumulated SCSI tree for 2.6.20.  It is available at
>
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

You once again have not included this two patches Andrew sent you on 20070602:

[patch 08/33] remove extra newline from info message
[patch 09/33] Fix scsi/scsi_transport.h compile error

Is this by mistake or intentional?

Greetings,

Eike

--nextPart6168428.fcT4MqvegJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBF0EGOXKSJPmm5/E4RAsAlAJ9yb3XOlBjnW0kzrZLIizALmhkGSwCfTY44
Ia3MPYEcPZEZ8nLQBEleiLM=
=rOAz
-----END PGP SIGNATURE-----

--nextPart6168428.fcT4MqvegJ--
