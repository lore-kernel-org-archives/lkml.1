Return-Path: <linux-kernel-owner+w=401wt.eu-S1764136AbXFKFTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764136AbXFKFTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 01:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbXFKFTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 01:19:32 -0400
Received: from www.osadl.org ([213.239.205.134]:42702 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750705AbXFKFTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 01:19:32 -0400
Subject: Re: [patch-mm 00/23] High resolution timer updates and x86_64
	support
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Lord <lkml@rtr.ca>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <466C7F44.1040309@rtr.ca>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de>
	 <466C7F44.1040309@rtr.ca>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 07:19:25 +0200
Message-Id: <1181539165.8176.38.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Sun, 2007-06-10 at 18:46 -0400, Mark Lord wrote:
> Do you know if there's anything specific in there that would fix
> the start-up race condition with HRTIMERS on my machine here
> (previously discussed, yet unresolved)?
> 
> It still happens sporadically on boot-up -- maybe one in 10 boots without
> any change in the kernel binary..

on which kernel version ?

	tglx



