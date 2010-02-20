Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab0BTJrK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 04:47:10 -0500
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:50696 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752524Ab0BTJrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 04:47:08 -0500
Date: Sat, 20 Feb 2010 10:47:03 +0100
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] thinkpad-acpi: fix link error to include sound arch
Message-ID: <20100220094703.GC2659@nuttenaction>
References: <1263820516-6924-1-git-send-email-hagen@jauu.net>
 <20100119145108.GD2668@khazad-dum.debian.net>
 <73f3c62cccfd75cb045a352320346c26@localhost>
 <20100207200506.GA25736@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100207200506.GA25736@khazad-dum.debian.net>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Henrique de Moraes Holschuh | 2010-02-07 18:05:06 [-0200]:

>No, you're correct, but the fix was already in its way to mainline when
>you sent your report.  I took some time to try to break it today, just
>in case there was something I missed.

OK, I was not aware of any efforts. I had vacation so I am little bit
outdated. I saw your patches and was impressed - nice work!

>What kernel was giving you trouble? I still need to fix the backports in
>the thinkpad-acpi git tree, maybe it was one of them?

No sure, somewhere in the area of 9db2f1bec36805e57a003f7bb90e003815d96de8
My posted patch applied to the HEAD of linus at this time.


Best regards, Hagen

-- 
Hagen Paul Pfeifer <hagen@jauu.net>  ||  http://jauu.net/
Telephone: +49 174 5455209           ||  Key Id: 0x98350C22
Key Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
