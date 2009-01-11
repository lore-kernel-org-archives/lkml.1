Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbZAKVf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbZAKVf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 16:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZAKVfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 16:35:14 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23120 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZAKVfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 16:35:13 -0500
Date: Sun, 11 Jan 2009 22:35:11 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29-rc1
In-Reply-To: <8db1092f0901111328m5bf74c8bh6361f8845f767d45@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.0901112232030.6354@swampdragon.chaosbits.net>
References: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain> <8db1092f0901111328m5bf74c8bh6361f8845f767d45@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jan 2009, Maciej Rutecki wrote:

> During booting system stops on this message:
> http://unixy.pl/maciek/download/kernel/2.6.29-rc1/laptop/img_0001.jpg
> 
> Probably I have two separate problems: warning (fragment is visible on
> top) and freeze of system. I try bisect, but I have problem:
> 
> root@gumis:/usr/src/git/linux-2.6# git bisect start
...snip...
> 
> I have only "fs" and ".git" directory after last "git bisect good".
> How to avoid this problem?
> 
See the thread with Subject "Subject: current git kernel has strange 
problems during bisect" - 
http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/c8009969743b80c1/6bcc34db7b940309?show_docid=6bcc34db7b940309
Especially the first post by Linus that tells you how to deal with it.

-- 
Jesper Juhl <jj@chaosbits.net>        http://personal.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

