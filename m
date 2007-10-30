Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbXJ3MN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbXJ3MN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 08:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbXJ3MNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 08:13:18 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:58685 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbXJ3MNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 08:13:17 -0400
Date: Tue, 30 Oct 2007 06:13:16 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Kumar Gala <galak@kernel.crashing.org>, Kyle McMartin <kyle@mcmartin.ca>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Only show RESOURCES_64BIT on relevant architectures
Message-ID: <20071030121315.GK32359@parisc-linux.org>
References: <20071028201549.GA23138@fattire.cabal.ca> <20071030024801.GA19417@linux-mips.org> <AFC1DED8-E331-420C-940E-9CF849630F0B@kernel.crashing.org> <20071030083719.GJ32359@parisc-linux.org> <20071030114221.GA24392@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030114221.GA24392@linux-mips.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 11:42:21AM +0000, Ralf Baechle wrote:
> On Tue, Oct 30, 2007 at 02:37:19AM -0600, Matthew Wilcox wrote:
> > On Mon, Oct 29, 2007 at 10:03:16PM -0500, Kumar Gala wrote:
> > > same HW platform that you want to run with just 32-bit phys (for  
> > > performance).
> > 
> > Have you measured what the performance difference is?
> 
> So that's 5668, 256 bytes data and 128 bytes of bss for a total of 6052
> bytes.  Not a whole lot but I still fear some users on the most
> claustrophobic systems will mind.

Oh, sure, I'm not saying I thought there would be no size difference; I
was just bemused at the suggestion there was a performance difference.

Unless "won't fit in ROM any more" is considered a performance problem ;-)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
