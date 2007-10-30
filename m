Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbXJ3Iha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbXJ3Iha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 04:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbXJ3IhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 04:37:22 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:51546 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbXJ3IhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 04:37:21 -0400
Date: Tue, 30 Oct 2007 02:37:19 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Only show RESOURCES_64BIT on relevant architectures
Message-ID: <20071030083719.GJ32359@parisc-linux.org>
References: <20071028201549.GA23138@fattire.cabal.ca> <20071030024801.GA19417@linux-mips.org> <AFC1DED8-E331-420C-940E-9CF849630F0B@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AFC1DED8-E331-420C-940E-9CF849630F0B@kernel.crashing.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 10:03:16PM -0500, Kumar Gala wrote:
> The same is true on PPC32.  Its a per platform thing.   However, I'm  
> not sure if we could hide it from the user.  There are cases on the  
> same HW platform that you want to run with just 32-bit phys (for  
> performance).

Have you measured what the performance difference is?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
