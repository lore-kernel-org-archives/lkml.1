Return-Path: <linux-kernel-owner+w=401wt.eu-S1030525AbXAaShZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030525AbXAaShZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 13:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030526AbXAaShZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 13:37:25 -0500
Received: from mx5.mail.ru ([194.67.23.25]:9424 "EHLO mx5.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030525AbXAaShZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 13:37:25 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: Free Linux Driver Development!
Date: Wed, 31 Jan 2007 21:37:21 +0300
User-Agent: KMail/1.9.5
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
References: <20070130012904.GA9617@kroah.com> <20070131040212.6057239B568@muan.mtu.ru> <20070131124933.6b32c4ff@localhost.localdomain>
In-Reply-To: <20070131124933.6b32c4ff@localhost.localdomain>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701312137.22324.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Wednesday 31 January 2007 15:49, Alan wrote:
> > Well, I have a long standing issue with pata_ali not detecting CD-ROM in
> > DMA mode. When I rarely watch DVD I rather boot into legacy IDE kernel
> > ...
>
> There is a general problem with some ATAPI devices and the probe logic
> currently. The old IDE code has some workarounds that the new libata
> layer doesn't yet do.
>

OK I hope to get chance to test new code someday ...

- -andrey
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFwOHiR6LMutpd94wRAltRAJ9eGY+ory798QPzPKvlMsiyy3iVZQCdHbJ7
BtUwkgxuPbi2jwwNqF46fMQ=
=ihjL
-----END PGP SIGNATURE-----
