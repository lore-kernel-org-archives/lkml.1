Return-Path: <linux-kernel-owner+w=401wt.eu-S1757994AbYG0XQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbYG0XQN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 19:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYG0XP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 19:15:59 -0400
Received: from mail.tmr.com ([64.65.253.246]:40907 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbYG0XP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 19:15:58 -0400
Message-ID: <488D03A9.4020103@tmr.com>
Date: Sun, 27 Jul 2008 19:24:25 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: luis6674@yahoo.com
CC: linux-kernel@vger.kernel.org
Subject: Re: How to disable group scheduler correctly?
References: <842240.12654.qm@web53310.mail.re2.yahoo.com>
In-Reply-To: <842240.12654.qm@web53310.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alberto Gonzalez wrote:
> Hello,
> 
> Could anyone tell me which options to enable/disable to have the scheduler behavior as it was before 2.6.25 (i.e, completely disable the group scheduler)? There seems to be a lot of confusion [1] about which options to set or not set, so it would be nice if anyone could give the exact ones.
> 
> Thanks.
> 
> [1] For example, in Arch Linux the group scheduler was first enabled in 2.6.25, but due to latency issues it was quickly disabled. But after that, the following report claims to have problems with everything *GROUP* disabled and that you need to enable CGROUPS to solve them (the report links to similar reports on Gentoo and Ubuntu, so it seems the confusion is quite general):
> 
> http://bugs.archlinux.org/task/10512
> 
Would be nice to have a clean way to do this at runtime, so you could 
run a distribution kernel and just avoid the group part of the scheduling.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
