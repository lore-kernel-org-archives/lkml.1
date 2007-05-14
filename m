Return-Path: <linux-kernel-owner+w=401wt.eu-S1761497AbXENBCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497AbXENBCy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 21:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756561AbXENBCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 21:02:48 -0400
Received: from mail.tmr.com ([64.65.253.246]:35789 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970AbXENBCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 21:02:47 -0400
Message-ID: <4647B54C.6080806@tmr.com>
Date: Sun, 13 May 2007 21:03:08 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: umesh@websurfer.com.np
CC: linux-kernel@vger.kernel.org
Subject: Re: upgrade linux kernel
References: <2417.63.219.2.2.1179056431.squirrel@mail.websurfer.com.np>
In-Reply-To: <2417.63.219.2.2.1179056431.squirrel@mail.websurfer.com.np>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

umesh@websurfer.com.np wrote:
> I am upgrading kernel from 2.4.20-8(default in RH9) to 2.6.xx. when I do
> "make" command it gives some output and finally get error saying that,
> 
> "BFD: Warning: Writing section '.bss' to huge ( ie negative) file offset
> 0xc0244000. "
> 
>  "Objcopy: arch/i386/boot/compressed/vmlinux.bin: file truncated"
> 
> "make[2]:***[ arch/i386/boot/compressed/vmlinux.bin] Error 1"
> 
>  "make[1]: ***[ arch/i386/boot/compressed/vmlinux] Error 2"
> 
>  "make: *** [bzImage] Error 2"
> 
You can upgrade a bunch of system utilities, but I'm not sure it's worth 
doing. The system I'm on is RH8.0 patched to run later kernels when my 
development machine went down. I got 2.5.52 to boot, last stable was 
2.5.47-ac6 and I gave up.

Unless you have some major need to upgrade the kernel without the 
distribution, grab the latest RH kernel, or use the latest 2.4 kernel 
available.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
