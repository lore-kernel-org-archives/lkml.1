Return-Path: <linux-kernel-owner+w=401wt.eu-S1030194AbXBFWyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030194AbXBFWyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030234AbXBFWyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:54:05 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54264 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030194AbXBFWyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:54:02 -0500
Date: Tue, 6 Feb 2007 14:53:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
In-Reply-To: <1170801484.29759.1000.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.64.0702061451560.8424@woody.linux-foundation.org>
References: <1170801484.29759.1000.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Feb 2007, David Woodhouse wrote:
> 
> I claim that there are _better_ ways to do it than 'select'.

I don't think you've ever showed any such example.

And if you did, it would all boil down to *exactly* what 'select' does: 
config options that get set automatically based on other choices.

So care to give a real example? Start with USB automatically selecting 
SCSI support without the user having to even know it uses SCSI. Tell me 
how it's supposed to work sanely without 'select'.

Put up, or shut up.

		Linus
