Return-Path: <linux-kernel-owner+w=401wt.eu-S933261AbYEAWwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261AbYEAWwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932849AbYEAWvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:51:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57147
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933118AbYEAWvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:51:52 -0400
Date: Thu, 01 May 2008 15:51:51 -0700 (PDT)
Message-Id: <20080501.155151.177031041.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, bunk@kernel.org, venkatesh.pallipadi@intel.com,
       trini@kernel.crashing.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: huge gcc 4.1.{0,1} __weak problem
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org>
References: <20080501215633.GU29330@cs181133002.pp.htv.fi>
	<20080501152051.4eb4bad3.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0805011525460.5994@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 May 2008 15:27:26 -0700 (PDT)

> So yes, we can distinguish 4.1.2 (good, and very common) from 4.1.{0,1} 
> (bad, and rather uncommon).
> 
> And yes, considering that 4.1.1 (and even more so 4.1.0) should be rare to 
> begin with, I think it's better to just not support it.

This is my impression as well.
