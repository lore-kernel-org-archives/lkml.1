Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbYK1MCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbYK1MCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 07:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYK1MCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 07:02:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:57748 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbYK1MCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 07:02:21 -0500
Message-ID: <492FDDD1.3040209@kernel.org>
Date: Fri, 28 Nov 2008 21:02:25 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Adrian Bunk <bunk@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Miklos Szeredi <miklos@szeredi.hu>,
       Takashi Iwai <tiwai@suse.de>, fuse-devel@lists.sourceforge.net
Subject: Re: [ANNOUNCE] OSS Proxy using CUSE
References: <48B6F711.1040604@kernel.org> <20080828200120.GA16462@cs181140183.pp.htv.fi> <alpine.LNX.1.10.0811272148490.23969@fbirervta.pbzchgretzou.qr> <492F5613.4090908@kernel.org> <alpine.LNX.1.10.0811281220510.3843@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0811281220510.3843@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Nov 2008 12:02:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
>> The devel version of ossp (not out yet, waiting for CUSE and mmap
>> support merge) can do all the quakes (even the dreaded quake1 which
>> even ALSA OSS emulation or native OSS can't do because of strict
>> sample/freq requirement which modern devices don't support anymore)
> 
> Quake won't be a problem because its source was released.

Well, it's still nice to just download the stock demo and being able
to run it.  Has q2 been open sourced too?

>> and skype-static-oss are working fine.
> 
> Skype should burn in hell...

Heh... it's the only working IP phone solution over here.

>> The latency is still a tad bit
>> high due to PA interaction but everything is mostly in place.  I'm
>> fairly sure UT would work too.  Do you know where I can get a demo of
>> it?
> 
> It has become really difficult to obtain these nowadays, but there it is:
> 
> http://download.beyondunreal.com/get.php/2/official/ut/utdemo-linux-x86-348.tar.gz
> 
> 
> (BTW, Firefox3 screws up on loading
> http://download.beyondunreal.com/fileworks.php/official/ut/utdemo-linux-x86-348.tar.gz
> w3m works fine and was used to obtain the nested link above.)

Thanks.  Will try that.

-- 
tejun
