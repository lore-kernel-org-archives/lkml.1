Return-Path: <linux-kernel-owner+w=401wt.eu-S935570AbXGMIf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935570AbXGMIf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 04:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761026AbXGMIfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 04:35:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:48578 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441AbXGMIfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 04:35:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fXoewELUuNSxEJumdcj/fquT7nKUZbNfZiMNuKSvfCwP4QDFHxQxqQjPVznrk4ZP+MHwWvdSop/QLZH20mL2GMJskvMFsFZMgqmmUkjJqSFhltVBc3uD5ACFokit5QDSOKGrd932Gs8whfWEGGCaJTzfrWCHY/e9FOEGP0/XJxY=
Message-ID: <4697393F.2070002@gmail.com>
Date: Fri, 13 Jul 2007 17:35:11 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: Tejun Heo <htejunu@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc6-mm1 -- BUG - EIP: [<c01a77a1>] sysfs_addrm_finish+0x1c2/0x226
 SS:ESP 0068:c5ff9db8
References: <a44ae5cd0707030932h16a90ca3j8ad65b7a3ec64b03@mail.gmail.com>	 <a44ae5cd0707060101g38147b2gb3d33d9903082113@mail.gmail.com>	 <468F36F5.4010803@gmail.com>	 <a44ae5cd0707071753g6dd4445bsaac2e2296327e510@mail.gmail.com>	 <469038EF.7040709@gmail.com>	 <a44ae5cd0707072156y7d0c9e5am2ded3efdc036bcf7@mail.gmail.com>	 <469484E1.6040000@gmail.com> <4694A769.7040502@gmail.com>	 <a44ae5cd0707111539l5e5adc4ct76ae2f4cb9063e58@mail.gmail.com>	 <46959A2C.7090908@gmail.com> <a44ae5cd0707120125u4c17020bvc9a3a28a24ef042a@mail.gmail.com>
In-Reply-To: <a44ae5cd0707120125u4c17020bvc9a3a28a24ef042a@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane wrote:
> Tejun,
> 
> I tried 2.6.22-rc6-mm1 + your latest patch, and it failed to boot.
> Unfortunately, the machine limped along and am unable to capture
> the initial BUG or OOPS.  I'll try to get a serial connection set up for
> debugging tomorrow, but I am very busy with other stuff.  It would be
> great if you could test your own build with the .config file I initially
> sent
> to you for the original BUG: issue.  If you would like me to resend the
> .config, just let me know.

Hmmm... I did test with your .config before posting the updated patch
and I just tested again.  It runs well on my ICH9 box.  I'm sorry but
I'll need to see the oops.

Thanks a lot.

-- 
tejun
