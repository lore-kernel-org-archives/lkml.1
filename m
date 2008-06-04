Return-Path: <linux-kernel-owner+w=401wt.eu-S1761232AbYFDRcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761232AbYFDRcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbYFDRcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:32:03 -0400
Received: from xenotime.net ([66.160.160.81]:35860 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753493AbYFDRcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:32:01 -0400
Date: Wed, 4 Jun 2008 10:31:59 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>, avorontsov@ru.mvista.com,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, wim@iguana.be, scottwood@freescale.com
Subject: Re: [PATCH 0/8 v4] mpc83xx_wdt rework, support for mpc8610 and
 mpc8xx
Message-Id: <20080604103159.80814067.rdunlap@xenotime.net>
In-Reply-To: <20080603211530.d6b3755a.akpm@linux-foundation.org>
References: <20080602173726.GA24556@polina.dev.rtsoft.ru>
	<20080603164830.32457962.akpm@linux-foundation.org>
	<20080604001739.GB24548@polina.dev.rtsoft.ru>
	<20080603173214.0bf71571.akpm@linux-foundation.org>
	<18502.5368.786188.835122@cargo.ozlabs.ibm.com>
	<20080603211530.d6b3755a.akpm@linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008 21:15:30 -0700 Andrew Morton wrote:

> On Wed, 4 Jun 2008 14:07:20 +1000 Paul Mackerras <paulus@samba.org> wrote:
> 
> > Looking at Linus' git tree, it's evident that some subsystems use the
> > the "[SUBSYSTEM]" notation and some use "subsystem:".  If there is now
> > an edict from on high that only "subsystem:" is acceptable, then I
> > must have missed that memo.
> 
> I'm all edicted out.  Sometimes one just puts forth the reasoning and
> lets others decide whether it's worth bothering about.  I could understand
> that decision being "no" :)

Well, it would be a Good Thing if all subsystem/arch maintainers would do it
in the same format, whatever that format is.

---
~Randy
<quote:>
"It's the Government of the United States." ... The largest, and yet
the least efficient, producer of computer software in the world.
