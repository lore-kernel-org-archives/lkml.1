Return-Path: <linux-kernel-owner+w=401wt.eu-S1752577AbXCRNFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbXCRNFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 09:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbXCRNFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 09:05:19 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:28653 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbXCRNFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 09:05:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=qvRjHmiF5XQQAVFKesKm3eZHyODWpnNLjL5lIvPGAp6R4fmTGqdcWPZQ0AzcBz3eGaV5RFDp+vxDifMeXQtJv00swih5zldF4qiNrmkejwMCxMrekWul8cLEn0IbAtydXIRIF2C6qN1wI4ohvulEYW7Vx39kAMZdnrQOeViuxCs=
Message-ID: <45FD38C0.4020205@googlemail.com>
Date: Sun, 18 Mar 2007 14:04:00 +0100
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Takashi Iwai <tiwai@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc4
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <45FAD77A.1070709@googlemail.com> <s5hbqitj9xi.wl%tiwai@suse.de> <6bffcb0e0703161203v699d9b21x8fa6bf5175916441@mail.gmail.com> <20070317234644.GN752@stusta.de>
In-Reply-To: <20070317234644.GN752@stusta.de>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk napisał(a):
> On Fri, Mar 16, 2007 at 08:03:29PM +0100, Michal Piotrowski wrote:
>> On 16/03/07, Takashi Iwai <tiwai@suse.de> wrote:
>>> At Fri, 16 Mar 2007 18:44:26 +0100,
>>> Michal Piotrowski wrote:
>>>> Takashi, unfortunately this bug isn't fixed
>>>> http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#1684
>>> The patch wasn't merged to rc4.
>> I know. I use patched 2.6.21-rc3-git4 for crashdump.
>>
>>> Or, do you mean the bug is still present even with the patch?
>> This patch doesn't fix the problem.
>> http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/3080.html
>>
>> Tomorrow, I'll try to provide more info about this problem.
> 
> You said at [1] that the patch from [2] (not yet merged into Linus' tree) 
> fixed this problem for you.


Sorry, it's my fault.

This patch doesn't fix the problem.

> 
> Or do I confuse anything?
> 
>> Regards,
>> Michal
> 
> cu
> Adrian
> 
> [1] http://lkml.org/lkml/2007/3/13/276
> [2] http://lkml.org/lkml/2007/3/7/540
> 

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
