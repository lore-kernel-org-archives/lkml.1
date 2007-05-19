Return-Path: <linux-kernel-owner+w=401wt.eu-S1762697AbXESTOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762697AbXESTOU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 15:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757414AbXESTON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 15:14:13 -0400
Received: from quechua.inka.de ([193.197.184.2]:37164 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912AbXESTOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 15:14:12 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: it seems at XFS bug?!
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <6101e8c40705191117h40c8af70sfc9d0617a99a248b@mail.gmail.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1HpUNW-00020n-00@calista.eckenfels.net>
Date: Sat, 19 May 2007 21:14:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <6101e8c40705191117h40c8af70sfc9d0617a99a248b@mail.gmail.com> you wrote:
> 0000500   8   6   1   2   5   4   9       -   r   w   -   r   -   -   r
>        3638 3231 3435 2039 722d 2d77 2d72 722d
> 0000520   -   -       1       r   o   o   t       r   o   o   t
>        2d2d 3120 7220 6f6f 2074 6f72 746f 2020
> 0000540                   0       2   0   0   7   -   0   5   -   0   6
>        2020 2020 2030 3032 3730 302d 2d35 3630
> 0000560       1   2   :   4   1          \n  \0
>        3120 3a32 3134 a020 000a
> 0000571

That file with the inode 8612549 has indeed an empty name. (And I wonder a
bit about the trailing \0, my ls does not do that?)

Gruss
Bernd
