Return-Path: <linux-kernel-owner+w=401wt.eu-S1751305AbXAXLxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbXAXLxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 06:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbXAXLxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 06:53:04 -0500
Received: from www.osadl.org ([213.239.205.134]:45485 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751305AbXAXLxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 06:53:03 -0500
Subject: Re: [patch] clocksource: fixup is_continous changes in vmitime.c
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <20070124112326.GA9937@elte.hu>
References: <20070123211159.178138000@localhost.localdomain>
	 <20070123211204.553722000@localhost.localdomain>
	 <20070124112326.GA9937@elte.hu>
Content-Type: text/plain
Date: Wed, 24 Jan 2007 12:53:19 +0100
Message-Id: <1169639599.21181.175.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 12:23 +0100, Ingo Molnar wrote:
> convert vmitime.c to the new clocksource flag.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Thomas Gleixner <tglx@linutronix.de>


