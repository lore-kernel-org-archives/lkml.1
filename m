Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbZETNt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbZETNt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 09:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbZETNtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 09:49:21 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:45809 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbZETNtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 09:49:21 -0400
Date: Wed, 20 May 2009 17:49:20 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       rth@twiddle.net, linux@arm.linux.org.uk, hskinnemoen@atmel.com,
       cooloney@kernel.org, starvik@axis.com, jesper.nilsson@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
       takata@linux-m32r.org, geert@linux-m68k.org, monstr@monstr.eu,
       ralf@linux-mips.org, kyle@mcmartin.ca, benh@kernel.crashing.org,
       paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       lethal@linux-sh.org, davem@davemloft.net, jdike@addtoit.com,
       chris@zankel.net, rusty@rustcorp.com.au
Subject: Re: [PATCHSET core/percpu] percpu: convert most archs to dynamic
	percpu
Message-ID: <20090520134920.GA1248@jurassic.park.msu.ru>
References: <1242805059-18338-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242805059-18338-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 04:37:32PM +0900, Tejun Heo wrote:
> Test config boots and works fine on x86_64.  alpha and s390 are
> compile tested and verified to generate necessary code for external
> references but I don't have any way to actually verify them, so please
> test them.  :-)

Works fine on alpha, thanks!

Acked-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Ivan.
