Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928AbYDDHjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbYDDHjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 03:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbYDDHjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 03:39:25 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:51985 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbYDDHjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 03:39:24 -0400
Date: Fri, 4 Apr 2008 09:39:18 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@elte.hu,
       davem@davemloft.net, hskinnemoen@atmel.com, cooloney@kernel.org,
       starvik@axis.com, dhowells@redhat.com, ysato@users.sourceforge.net,
       takata@linux-m32r.org, geert@linux-m68k.org, ralf@linux-mips.org,
       kyle@parisc-linux.org, paulus@samba.org, schwidefsky@de.ibm.com,
       lethal@linux-sh.org, jdike@addtoit.com, miles@gnu.org, chris@zankel.net,
       rmk@arm.linux.org.uk, tony.luck@intel.com
Subject: Re: [RFC 17/22] s390: Use generic show_mem()
Message-ID: <20080404073918.GA6910@osiris.boeblingen.de.ibm.com>
References: <12071688283927-git-send-email-hannes@saeurebad.de> <12071690203023-git-send-email-hannes@saeurebad.de> <20080403075029.GB4125@osiris.boeblingen.de.ibm.com> <87iqyzozyx.fsf@saeurebad.de> <20080403175856.GA4131@osiris.boeblingen.de.ibm.com> <87lk3umuny.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lk3umuny.fsf@saeurebad.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Btw. your patch regarding the removal of show_free_areas() from
> > s390's arch code will be merged during the next merge window.
> 
> Okay.
> 
> Do you mean the removal of
> 
> 	printk("Free swap:       %6ldkB\n", nr_swap_pages << (PAGE_SHIFT
> 		- 10));
> 
> in show_mem()?  This was my last patch series about.

Yes.

> Can I add your Acked-by for _this_ series?

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
