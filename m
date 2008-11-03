Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbYKCE6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbYKCE6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 23:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbYKCE6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 23:58:41 -0500
Received: from xenotime.net ([72.52.64.118]:40641 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754522AbYKCE6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 23:58:40 -0500
Date: Sun, 2 Nov 2008 20:58:17 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Peter Teoh" <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, adobriyan@gmail.com
Subject: Re: removal of fs/proc/inode-alloc.txt
Message-Id: <20081102205817.eb6cbe19.rdunlap@xenotime.net>
In-Reply-To: <804dabb00811010013t2594a03fw3cef35a2f39a4f80@mail.gmail.com>
References: <804dabb00811010013t2594a03fw3cef35a2f39a4f80@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2008 15:13:49 +0800 Peter Teoh wrote:

> I find it weird, that a text file should exists among the directories
> of C and header files.   If it is a legitimate documentation it should
> go into Documentation subdirectory, correct?   Or if it is so short
> like it currently is, go into some C file.
> 
> Anyway I don't understand anything about this text file, and from its history:
> 
> http://www.google.com/search?q=site%3Alkml.org+%22inode-alloc.txt%22&btnG=Google+Search
> 
> I don't see its purpose here.
> 
> Can someone comment on its history, can it be removed?

Alexey,

With your /proc changes, can you please find a source file to hold this
small file's comments?  or should it just be removed?

Thanks,
---
~Randy
