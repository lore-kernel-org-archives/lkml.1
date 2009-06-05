Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbZFEE1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbZFEE1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 00:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZFEE1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 00:27:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:52387 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbZFEE13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 00:27:29 -0400
Message-ID: <4A289DF8.10901@kernel.org>
Date: Fri, 05 Jun 2009 13:24:24 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Kyle McMartin <kyle@mcmartin.ca>
CC: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux@arm.linux.org.uk,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, takata@linux-m32r.org,
       geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org,
       benh@kernel.crashing.org, paulus@samba.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, lethal@linux-sh.org, davem@davemloft.net,
       jdike@addtoit.com, chris@zankel.net, rusty@rustcorp.com.au
Subject: Re: [GIT PATCH core/percpu] percpu: convert most archs to dynamic
 percpu, take#2
References: <1243846708-805-1-git-send-email-tj@kernel.org> <20090601161028.GA30851@bombadil.infradead.org> <20090601195103.GA6280@bombadil.infradead.org>
In-Reply-To: <20090601195103.GA6280@bombadil.infradead.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 05 Jun 2009 04:24:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> On Mon, Jun 01, 2009 at 12:10:28PM -0400, Kyle McMartin wrote:
>> On Mon, Jun 01, 2009 at 05:58:21PM +0900, Tejun Heo wrote:
>>>  arch/parisc/kernel/irq.c                         |    2 
>>>  arch/parisc/kernel/topology.c                    |    2 
>> Ack the parisc bits, they build correctly, and appear to boot fine
>> as well (at least, limited testing.)
>>
> 
> I appear to have spoken too soon (or booted the wrong machine.) I'll
> look into it.

Any news?

Thanks.

-- 
tejun
