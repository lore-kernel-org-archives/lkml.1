Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbZKHPao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbZKHPao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 10:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbZKHPam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 10:30:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50451 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbZKHPaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 10:30:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] Please get this committed, _NOW_ (preferrably 5 years ago), thanks.
Date: Sun, 8 Nov 2009 16:30:32 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Andreas Mohr <andi@lisas.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Michael A. Griffith" <grif@acm.org>, linux-kernel@vger.kernel.org
References: <20091108120008.GA21611@rhlx01.hs-esslingen.de> <20091108144548.GA13429@rhlx01.hs-esslingen.de> <20091108151153.GC6240@hack>
In-Reply-To: <20091108151153.GC6240@hack>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <200911081630.32926.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18w02E/Nvz88XAWNuRtZvsfPpQdgCbegHG1be1
 JjKHtl5UpOUjuNeusdqnGrXMP+HjmUwaJvdv0S5pxqS4Mr1Gvo
 jx99YxEkif5fh4wMgGL1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 November 2009, Américo Wang wrote:
> >Plus in my case it was a kernel issue (problematic/non-working serial
> >console device). And except for the linker issues of missing libraries,
> >many issues (USB functionality etc.) were kernel-related, too.
> 
> Yeah, I mentioned it to mean it is not suitable to explain
> user-space problems in a kernel source file. Putting it into a kernel
> doc should be fine.

I think it would be best to put it on a wiki page, e.g. on kernelnewbies.org
and point to that. That means you will be able to add information to it
independent of the kernel version.

	Arnd <><
