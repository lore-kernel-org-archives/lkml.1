Return-Path: <linux-kernel-owner+w=401wt.eu-S1764516AbYBMAdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764516AbYBMAdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbYBMAc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:32:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55004
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754342AbYBMAc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:32:56 -0500
Date: Tue, 12 Feb 2008 16:33:28 -0800 (PST)
Message-Id: <20080212.163328.210878831.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, jeff@garzik.org,
       arjan@infradead.org, greg@kroah.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org>
	<1202840682.3137.83.camel@localhost.localdomain>
	<alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Feb 2008 10:48:38 -0800 (PST)

> On Tue, 12 Feb 2008, James Bottomley wrote:
> > Yes ... I don't do that ... Like I said, I only rebase for an actual
> > conflict.
> 
> And this is how things should work. 

And if conflicts happen every day, what should someone do?

This isn't fantasy, that's exactly how things got with the
networking tree near the end of 2.6.24.
