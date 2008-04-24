Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbYDXE5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbYDXE5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 00:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbYDXE4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 00:56:23 -0400
Received: from rv-out-0708.google.com ([209.85.198.251]:20084 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753770AbYDXE4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 00:56:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=BheTRDlQgXwMeSj2flAOa3x+HydSu2ArkmHnxKRztGMXd6R0WH1EEE7mJIrYrXT9TDcD2X+dzToKljims68K4417+Z/vhbJTdPIcRCnk4VLnFiNn0qj8xC9fhJIoGlG/q9TbAStxUNDxR9apPESjAiWU6c5rIra7jGD9wD0B5+8=
Date: Thu, 24 Apr 2008 12:55:38 +0800 (CST)
Message-Id: <20080424.125538.43013250.xiyou.wangcong@gmail.com>
To: abdel@benamrouche.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: unofficial linux-0.01-3.5
From: WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <c913039c0804221404h5d387d61i9f1c2e1006c88c8d@mail.gmail.com>
References: <c913039c0804221404h5d387d61i9f1c2e1006c88c8d@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Abdel !" <abdel@benamrouche.com>
Date: Tue, 22 Apr 2008 23:04:45 +0200
> Hello,
> 
> I have released linux 0.01-3.3 on january 1, 2008.
> And I often be asked 2 question :
> 
> the 1st was, "I can't build linux-0.01-3.3, why ?"
> ===================================
> 
> Well linux 0.01 was very well written, except 1 thing in the
> Makefile :
> To get file size of the kernel image, Linus Torvalds used the
> following ( and ugly ) command :
> "ls -l tools/system | grep system | cut -c31-37" which may be invalid
> for you.
> 
> So the unofficial linux-0.01-3.5 ( which was released on the end of
> January ) fix that and use
> stat command instead. It should work on any computer.
> 
> by the way, linux 0.01 rocks !
> a very small kernel, well writen, easy to understand and wich can do
> real kernel job !
> (  scheduler works, paging system was already implemented,  filesystem
> worked in a different thread, and main syscall was already implemented )
> 
> 
> the 2nd question was "I can't access to you website, where can I get
> the source ?"
> =====================================================
> 
> I get some mail from chinese guy saying that they can't access  to
> http://draconux.free.fr/os_dev/linux0.01.html
> I suppose even http://free.fr will not work.
> Maybe this is because of politics problem between France and China ?

I am in China.
I can visit http://free.fr, but not http://draconux.free.fr.

> 
> Anyway, you can get the last kernel source code here:
> http://www.kernel.org/pub/linux/kernel/people/abdel/linux_0.01/sources/linux-0.01-rm-3.5.tar.gz
> hopefully kernel.org work in any country :D

Yes, this one works.

Thanks for your work.

