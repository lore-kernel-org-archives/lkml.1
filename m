Return-Path: <linux-kernel-owner+w=401wt.eu-S1759445AbZFBGkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445AbZFBGkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 02:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbZFBGki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 02:40:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:39235 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbZFBGkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 02:40:37 -0400
Subject: Re: [GIT PATCH core/percpu] percpu: convert most archs to dynamic
 percpu, take#2
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tejun Heo <tj@kernel.org>
Cc: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux@arm.linux.org.uk,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, takata@linux-m32r.org,
       geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org,
       kyle@mcmartin.ca, paulus@samba.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, lethal@linux-sh.org, davem@davemloft.net,
       jdike@addtoit.com, chris@zankel.net, rusty@rustcorp.com.au
In-Reply-To: <1243846708-805-1-git-send-email-tj@kernel.org>
References: <1243846708-805-1-git-send-email-tj@kernel.org>
Content-Type: text/plain
Date: Tue, 02 Jun 2009 16:35:52 +1000
Message-Id: <1243924552.5308.33.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-01 at 17:58 +0900, Tejun Heo wrote:
> Hello,
> 
> Upon ack, please pull from the following git tree.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu
> 
> This is the second take of percpu-convert-most-archs-to-dynamic-percpu
> patchset.  Changes from the last take[L] are

There's a minor conflict with my -next branch but it's easy enough
to resolve by hand (Kconfig bits). Appart from that, it appears to
build fine with my collection of test configs. I haven't had a chance
to test boot it yet though :-)

Cheers,
Ben.


