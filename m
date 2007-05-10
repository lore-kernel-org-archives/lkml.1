Return-Path: <linux-kernel-owner+w=401wt.eu-S1761449AbXEJPDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761449AbXEJPDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760134AbXEJPDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:03:38 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:47221 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbXEJPDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:03:37 -0400
Date: Thu, 10 May 2007 16:59:44 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Bodo Eggert <7eggert@gmx.de>
cc: Albert Cahalan <acahalan@gmail.com>, Andrey Borzenkov <arvidjaar@mail.ru>,
       hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: Long file names in VFAT broken with iocharset=utf8
In-Reply-To: <E1Hm9xo-0000vV-Po@be1.lrz>
Message-ID: <Pine.LNX.4.61.0705101654480.24536@yvahk01.tjqt.qr>
References: <8ipOe-5KI-3@gated-at.bofh.it> <8ityz-2Xz-31@gated-at.bofh.it>
 <8iWqS-5Ba-15@gated-at.bofh.it> <8iWKp-619-29@gated-at.bofh.it>
 <8j4eK-QR-13@gated-at.bofh.it> <E1Hm9xo-0000vV-Po@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 10 2007 16:49, Bodo Eggert wrote:
>
>Just because you limit yourself to 80 chars minus "ls -l"-clutter, this is
>no reason why I shouldn't use long filenames. If I need to handle these
>filenames, I can enlarge the terminal window or read the next line.
>
>E.g.: I have a music file named "artist - title.ext", where the artist
>name is 103 characters long, using abbreviations. In order to enter that
>name, I have to press seven keys, including the escape character.
>There is nothing unreasonable in using that name.

What name would that be? I cannot dream up any IME that outputs _that_
many characters for that few keystrokes. Even with CJ(K), 7 keystrokes can
make at most 21 bytes if I had to take a good guess.


	Jan
-- 
