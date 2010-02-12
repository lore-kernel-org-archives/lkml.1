Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab0BLULM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 15:11:12 -0500
Received: from mbox1.netikka.net ([213.250.81.202]:56899 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517Ab0BLULI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 15:11:08 -0500
Message-ID: <4B75B5D8.5080602@mandriva.org>
Date: Fri, 12 Feb 2010 22:11:04 +0200
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100122 Mandriva/3.0.1-2mdv2010.1 (2010.1) Thunderbird/3.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.33-rc8
References: <alpine.LFD.2.00.1002121142100.3922@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002121142100.3922@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

12.02.2010 21:49, Linus Torvalds skrev:
>
> I think this is going to be the last -rc of the series, so please do test
> it out. A number of regressions should be fixed, and while the regression
> list doesn't make me _happy_, we didn't have the kind of nasty things that
> went on before -rc7 and made me worried.
>
> Some of the highlights inclure a netfilter/namespace bugfix, which
> apparently got visibility now that a number of distributions seem to have
> turned on the network namespace code. And more KMS regression fixes for
> all the usual suspects - intel, nouveau, radeon (hopefully not causing
> anything new).
>
> The rest is random stuff all over. Mostly one-liners, except for a
> defconfig update for mips (that also show up in the dirstat).
>
> 		Linus
>


Has the mirroring broken down ?

last thing I get out of git is:

commit 676ad585531e965416fd958747894541dabcec96
Merge: ffaa60d cab4d27
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Feb 11 14:07:13 2010 -0800

     Merge branch 'for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp

     * 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp:
       amd64_edac: Do not falsely trigger kerneloops


And the same thing is shown on:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=summary

I'm in Finland, so I assume the European mirrors are responding,
but trying to use master.kernel.org or git.us.kernel.org shows the same...

--
Thomas
