Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbZHLQiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbZHLQiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbZHLQiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:38:23 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:42625 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZHLQiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:38:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=K1PTIRBW38T/nKY/Iagp8jj6Q0u0THQH657FjVW7f9lyY047CQiIP1jIwVOF3S8zSE
         yWwFQT4F7xmJo5MP74WoMkfzEPgMzUVSy8+rrp8STWHFhiPiWNjvoiojYPMAq0HZL8x6
         Qb7Lkb87l0EfOba6WdSevdqR3Huy1tcNheAaQ=
Message-ID: <4A82EEB5.70506@gmail.com>
Date: Wed, 12 Aug 2009 18:32:53 +0200
From: Sandro Bonazzola <sandro.bonazzola@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090722)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Pavel Machek <pavel@ucw.cz>, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] w35und: Remove some write-only struct members
References: <1250064219-7372-1-git-send-email-penberg@cs.helsinki.fi>	 <1250064219-7372-2-git-send-email-penberg@cs.helsinki.fi>	 <1250064219-7372-3-git-send-email-penberg@cs.helsinki.fi>	 <1250064219-7372-4-git-send-email-penberg@cs.helsinki.fi>	 <1250064219-7372-5-git-send-email-penberg@cs.helsinki.fi>	 <1250064219-7372-6-git-send-email-penberg@cs.helsinki.fi>	 <1250064219-7372-7-git-send-email-penberg@cs.helsinki.fi>	 <20090812081550.GG23832@elf.ucw.cz> <84144f020908120121j542a895fw5f4cdda18890d417@mail.gmail.com>
In-Reply-To: <84144f020908120121j542a895fw5f4cdda18890d417@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Pekka Enberg wrote:

> OK, do you still want to be CC'd on the patches? I much appreciate the review!

Yes, feel free to CC me for 235und patches. I've not so much time but I'll try
yo test them as soon as I can.


- --
Sandro
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkqC7rUACgkQV871CybFeznITwCeLSzP7SCYlzqTt9aC8iaQRH9U
mZwAoKpKPPT4MKq1zidLGLgOoG9NuX2M
=Syvz
-----END PGP SIGNATURE-----
