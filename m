Return-Path: <linux-kernel-owner+w=401wt.eu-S1763210AbXGFKMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763210AbXGFKMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 06:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762767AbXGFKMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 06:12:06 -0400
Received: from post.kiewel-online.de ([85.214.49.162]:41479 "EHLO
	post.kiewel-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762685AbXGFKMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 06:12:03 -0400
Message-ID: <468E155E.7060402@kiewel-online.de>
Date: Fri, 06 Jul 2007 12:11:42 +0200
From: Uwe Kiewel <mailing-list@kiewel-online.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PATA-disk named sda
References: <20070706102132.14fbc600.Christoph.Pleger@cs.uni-dortmund.de>
In-Reply-To: <20070706102132.14fbc600.Christoph.Pleger@cs.uni-dortmund.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Christoph Pleger schrieb:
> Hello,
> 
> In the newest Ubuntu Release, my PATA-disk is called sda instead of hda.
> Is that a general feature in newer kernel versions or is it a special
> feature in Ubuntu?

IIRC it is relatet to a new libata2 library. My Fedora 7 shows the same
behavior.

Regrads,
Uwe
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGjhVer6SFaBB7DLURAs9kAKCutDEn7kfxpKQia3zP6i0WIoXsRwCfQgDl
/nNcRPH3lzrzy3pGuNDZAsw=
=xPle
-----END PGP SIGNATURE-----
