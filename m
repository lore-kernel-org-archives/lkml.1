Return-Path: <linux-kernel-owner+w=401wt.eu-S966098AbXJPVe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966098AbXJPVe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 17:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933879AbXJPVen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 17:34:43 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:57340 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933653AbXJPVem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 17:34:42 -0400
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [GIT PULL (updated)] kbuild updates
Date: Wed, 17 Oct 2007 00:34:56 +0300
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>
References: <20071015205018.GA24467@uranus.ravnborg.org> <20071016211101.GA4093@gentoox2.trippelsdorf.de>
In-Reply-To: <20071016211101.GA4093@gentoox2.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710170034.56804.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wednesday 17 October 2007 Tarihinde 00:11:01 yazmıştı:
[...]
> Bisecting shows that:
>
> commit f77bf01425b11947eeb3b5b54685212c302741b8
> 	Author: Sam Ravnborg <sam@neptun.(none)>
>  	Date:   Mon Oct 15 22:25:06 2007 +0200
>
>     kbuild: introduce ccflags-y, asflags-y and ldflags-y
>
> breaks booting with grub here. Grub stops with error 28:
> Selected item cannot fit into memory.
>
> Reverting the commit fixes the problem.

Same issue here.

-- 
Faith is believing what you know isn't so -- Mark Twain
