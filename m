Return-Path: <linux-kernel-owner+w=401wt.eu-S1757038AbXJ2Hmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbXJ2Hmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 03:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbXJ2Hmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 03:42:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55604 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751918AbXJ2Hmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 03:42:46 -0400
Date: Mon, 29 Oct 2007 00:42:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Daniel Cid" <dcid@ossec.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Unable to handle kernel NULL pointer dereference
Message-Id: <20071029004242.cbf528d0.akpm@linux-foundation.org>
In-Reply-To: <44003d360710221017k58ce3c2cqb2feff2939b65dae@mail.gmail.com>
References: <44003d360710221017k58ce3c2cqb2feff2939b65dae@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 14:17:14 -0300 "Daniel Cid" <dcid@ossec.net> wrote:

> Sorry if it isn't the right place to ask this question, but I was
> reported the following error in the kernel.
> 
> Syscheckd (process in the crash) is a userland (no kernel/lkm code)
> file integrity checking tool that scans the system and generates the
> md5/sha1 sum of all the files (if it helps to identify the problem).
> 
> I am guessing it is a bug in the kernel, since no user process should
> cause this...
> 
> 
> [root@ss ossec]# uname -a
> Linux ss 2.6.9-55.0.9.ELsmp #1 SMP Thu Sep 27 18:27:41 EDT 2007 i686 i686
> i386 GNU/Linux
> 

Sorry, we all stopped thinking about 2.6.9 years ago - unless you're able
to reproduce this on a current kernel (for example, latest Fedora), the
place to report this is https://bugzilla.redhat.com/

Thanks.
