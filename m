Return-Path: <linux-kernel-owner+w=401wt.eu-S1161395AbXBZXTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161395AbXBZXTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 18:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161397AbXBZXTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 18:19:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161395AbXBZXTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 18:19:23 -0500
Message-ID: <45E36AEB.7030800@redhat.com>
Date: Mon, 26 Feb 2007 18:19:07 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       nfs@lists.sourceforge.net
Subject: Re: Hang when shutting down - seems umount and NFS related - kernel
 version 2.6.18.1
References: <9a8748490702261504n147aa444y779153c03a2d44a2@mail.gmail.com>
In-Reply-To: <9a8748490702261504n147aa444y779153c03a2d44a2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> I have a server that has the sole job of serving up a bunch of NFS
> filesystems to webservers. The server is running kernel 2.6.18.1
> 
> A few days ago when attempting to reboot the server, the shutdown
> process hung with a backtrace on the console. A photo was taken and is
> available here:
>  http://www.kernel.org/pub/linux/kernel/people/juhl/images/DSC00504.jpg
> 
> A quick (incomplete) text transcript of the photo is here:
> 
> EIP: [<c01a51a0>] nfs_clear_inode+0x61/0x6b SS:ESP 0068:eb476ee4
> BUG: warning at kernel/exit.c:855/do_exit()

The real oops has scrolled off the screen.

