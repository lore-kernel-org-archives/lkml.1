Return-Path: <linux-kernel-owner+w=401wt.eu-S1763251AbXE1UYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763251AbXE1UYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 16:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbXE1UYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 16:24:25 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:18647 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbXE1UYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 16:24:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p4FaBcyEbwczYU4ZL59sqMpQCthzXMeb33NU2lZOJ+K/ZXyutIzFwTPnZxQlodpceOEquPaa2IQ4rM3K4qpuZtNbhiMbxzSF4jsmU0PHsLRA8ABI2I9nsbAVztJNQ9R6Eywp4ykIWiC7FZfcU/o6Z0kIgcP5SKZ4hsZc7s9vsbo=
Message-ID: <9a8748490705281324u509d9019qa7e60e446ca509b9@mail.gmail.com>
Date: Mon, 28 May 2007 22:24:24 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: stuff ready to be deleted?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705281612560.15449@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705281612560.15449@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/05/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
>
>   i'm trying to keep track of kernel janitor projects that involve
> removing dead content from the tree:
>
> http://fsdev.net/wiki/index.php?title=Kernel_Janitor%27s_Todo_List
>
> currently, the list contains the items:
>
>     * 1 Legacy power management
>     * 2 PCMCIA IOCTL support
>     * 3 Traffic shaper
>     * 4 Traffic policing
>     * 5 Userspace queueing via NETLINK
>     * 6 ebt: ulog support
>     * 7 MOXA SmartIO support
>     * 8 Old I2O ioctls
>     * 9 Stallion drivers
>     * 10 SDL RISCom/8 support
>     * 11 Macintosh M68K support
>     * 12 Commodore A2232 serial support
>     * 13 CONFIG_FORCED_INLINING
>     * 14 kernel_thread()
>
> which of the above are legitimate candidates for removal?  which are
> already underway in someone's local tree?  anything else that can
> be added?  etc, etc.
>

Take a look at Documentation/feature-removal-schedule.txt
Some of that stuff is already listed there along with who is in charge
of removing it and when.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
