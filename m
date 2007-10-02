Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbXJBWHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbXJBWHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 18:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbXJBWHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 18:07:05 -0400
Received: from mail.tmr.com ([64.65.253.246]:37252 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593AbXJBWHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 18:07:04 -0400
Message-ID: <4702C276.3080400@tmr.com>
Date: Tue, 02 Oct 2007 18:13:10 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <18178.22876.980673.839094@stoffel.org>
In-Reply-To: <18178.22876.980673.839094@stoffel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Stoffel wrote:
> Linus> I said I was hoping that -rc8 was the last -rc, and I hate
> Linus> doing this, but we've had more changes since -rc8 than we had
> Linus> in -rc8. And while most of them are pretty trivial, I really
> Linus> couldn't face doing a 2.6.23 release and take the risk of some
> Linus> really stupid brown-paper-bag thing.
> 
> Linus> So there's a final -rc out there, and right now my plan is to
> Linus> make this series really short, and release 2.6.23 in a few
> Linus> days. So please do give it a last good testing, and holler
> Linus> about any issues you find!
> 
> Just to let people know, I was running 2.6.23-rc for over 53 days
> without any issues.  Mix of SCSI, Sata, tape drives, disks, MD, LVM,
> SMP, etc.  I suspect we've got a pretty darn stable release coming out
> soon.
> 
I've been running rc8-git3 since it came out, and while I've built git-5 
and will build rc9, I probably will continue testing until I find a bug 
or have to boot for some other reason. Running really well, even with a 
lot of kvm stuff going on, kernel builds for other machines, etc.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
