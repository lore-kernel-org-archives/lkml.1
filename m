Return-Path: <linux-kernel-owner+w=401wt.eu-S1760782AbXKTX1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782AbXKTX1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761537AbXKTX1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:27:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761439AbXKTX1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:27:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/18] x86 vDSO: arch/x86/vdso/vdso32
In-Reply-To: Thomas Gleixner's message of  Wednesday, 21 November 2007 00:07:28 +0100 <alpine.LFD.0.9999.0711202348470.25057@localhost.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
	<20071119220425.6002E26F8BE@magilla.localdomain>
	<alpine.LFD.0.9999.0711201402520.25057@localhost.localdomain>
	<20071120205759.3533A26F8BE@magilla.localdomain>
	<alpine.LFD.0.9999.0711202348470.25057@localhost.localdomain>
X-Shopping-List: (1) Vehement aspersions
   (2) Aesthetic pliers
   (3) Erratic friction compulsions
Message-Id: <20071120232715.0803426F8BE@magilla.localdomain>
Date: Tue, 20 Nov 2007 15:27:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> git format-patch -p
> 
> does the trick at least here :)

Ok, I can use that in future.  I hope it still means that in the eventual
merged state, GIT will be aware of all the renames.


Thanks,
Roland
