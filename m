Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYEYQow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYEYQow (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 12:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbYEYQoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 12:44:44 -0400
Received: from 57.Red-88-2-100.staticIP.rima-tde.net ([88.2.100.57]:42727 "EHLO
	mail.leals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbYEYQon convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 12:44:43 -0400
From: Davi Leal <davi@leals.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: I am a volunteer
Date: Sun, 25 May 2008 18:44:39 +0200
User-Agent: KMail/1.9.7
Cc: "Tom Spink" <tspink@gmail.com>, linux-kernel@vger.kernel.org
References: <200805251812.41552.davi@leals.com> <7b9198260805250914j6bec961ev6dad20f8779e4dca@mail.gmail.com> <e2e108260805250920m3610edf7y613b4abc24d4f0ee@mail.gmail.com>
In-Reply-To: <e2e108260805250920m3610edf7y613b4abc24d4f0ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200805251844.40005.davi@leals.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche wrote:
> > http://kernelnewbies.org/
>
> The above URL points to a page with a.o. a link to the kernel janitors
> to do list, which might be what you are looking for:
> http://kernelnewbies.org/KernelJanitors/Todo.

>From the above link I have picked the below task. If that is already done I 
will pick another easy one. Any correction, suggestion, etc. is welcome:

  * Code that depends on LINUX_VERSION_CODE & KERNEL_VERSION < 2.6 can be
    * deleted in most cases. (Mostly/all? done)


Against what git repository should I do the check, 
linux/kernel/git/torvalds/linux-2.6.git ?

P.S.: I have subscribed to kernel-janitors, etc.
