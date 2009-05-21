Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbZEUBYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbZEUBYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 21:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbZEUBY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 21:24:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:42293 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbZEUBY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 21:24:26 -0400
Message-ID: <4A14ACA4.6050602@kernel.org>
Date: Thu, 21 May 2009 10:21:40 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux@arm.linux.org.uk,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, takata@linux-m32r.org,
       geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org,
       kyle@mcmartin.ca, benh@kernel.crashing.org, paulus@samba.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, lethal@linux-sh.org,
       davem@davemloft.net, jdike@addtoit.com, chris@zankel.net,
       rusty@rustcorp.com.au
Subject: Re: [PATCHSET core/percpu] percpu: convert most archs to dynamic
 percpu
References: <1242805059-18338-1-git-send-email-tj@kernel.org>
In-Reply-To: <1242805059-18338-1-git-send-email-tj@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 01:21:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> Please do NOT pull before maintainers of alpha and s390 ack.  Upon
> ack, please pull from the following git tree.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu

Ingo, I added Martin's and Ivan's acks.  Please go ahead and pull into
core/percpu.

Thanks.

-- 
tejun
