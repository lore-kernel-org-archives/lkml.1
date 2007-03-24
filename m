Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbXCXGdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbXCXGdW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 02:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbXCXGdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 02:33:21 -0400
Received: from www.osadl.org ([213.239.205.134]:59712 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753403AbXCXGdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 02:33:21 -0400
Subject: Re: [2/5] 2.6.21-rc4: known regressions (v2)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <46046D6D.3030202@madrabbit.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323184828.GP752@stusta.de>  <46046D6D.3030202@madrabbit.org>
Content-Type: text/plain
Date: Sat, 24 Mar 2007 07:40:37 +0100
Message-Id: <1174718438.10840.399.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray,

On Fri, 2007-03-23 at 17:14 -0700, Ray Lee wrote:
> (I wondered about the IPI on a UP system, seemed a bit weird :-).)
> 
> Works great, booting both with NOAPIC and without. *Much* thanks for
> debugging this while you're also handling a bunch of other issues at
> the same time.

Thank you for debugging and excellent problem descriptions !

> Patch reproduced below, with an acked-by (and, uhm, a couple of spelling
> fixes in the description -- don't hate me, 'kay?).

I know that my English sucks.

Thanks,

	tglx


