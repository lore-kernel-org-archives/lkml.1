Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbXEOHAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbXEOHAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 03:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbXEOHAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 03:00:10 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:7408 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbXEOHAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 03:00:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=PIkp9Cfrui1cTcNw5/9/bHSNoUzrqidkkuc3nqzSNrLKWURSiDkbBQ6xNCVApVIA1zOUGz8qC79I4uGqQcSbbiw/csL62IH+LUOeQTosVm4S6JgAfdz1FS7f6+M98/n1V51bvx0g2VsLdPgV7Wr3Zl5Osa4h1+cnynRI8I6xvWQ=
Message-ID: <46495A5C.4050609@gmail.com>
Date: Tue, 15 May 2007 08:59:40 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Francesco Pretto <ceztko@gmail.com>
CC: Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no>	 <fa.YHt2nIlQmoW5r2enmTSzsaySwH4@ifi.uio.no> <45DD0348.5040005@shaw.ca>	 <e5ab0f710702231235ucb559eerb3639ec312aa312a@mail.gmail.com>	 <463B858E.6060002@cfl.rr.com> <463B99EE.2090001@gmail.com>	 <e5ab0f710705061119k35ba223j2ecca6e0f8495ed5@mail.gmail.com>	 <46489D3B.8050805@gmail.com> <e5ab0f710705141346o45ac8721jacbcb753f9d45406@mail.gmail.com>
In-Reply-To: <e5ab0f710705141346o45ac8721jacbcb753f9d45406@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francesco Pretto wrote:
> 2007/5/14, Tejun Heo <htejun@gmail.com>
>>
>> Okay, the patch made upstream and webpage posted.
>>
>>  http://linux-ata.org/shutdown.html
>>
>> -- 
>> tejun
>>
> 
> Ubuntu [1] ang Gentoo [2] bugs opened. Sent a mail to Miquel van
> Smoorenburg, dev  of sysvinit.
> 
> [1] https://bugs.launchpad.net/upstart/+bug/114683
> [2] http://bugs.gentoo.org/show_bug.cgi?id=178559

Thanks a lot.  I've notified suse.  I'll ask Jeff whether rh is notified.

-- 
tejun
