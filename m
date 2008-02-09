Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbYBIQVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbYBIQVX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 11:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbYBIQVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 11:21:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47268 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbYBIQVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 11:21:05 -0500
Date: Sat, 9 Feb 2008 17:56:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Prakash Punnoor <prakash@punnoor.de>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       lenb@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
Message-ID: <20080209165619.GB24548@one.firstfloor.org>
References: <20080207195519.GA21772@basil.nowhere.org> <200802091253.11478.prakash@punnoor.de> <20080209143131.GD22569@one.firstfloor.org> <200802091651.06240.prakash@punnoor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802091651.06240.prakash@punnoor.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 09, 2008 at 04:51:05PM +0100, Prakash Punnoor wrote:
> On the day of Saturday 09 February 2008 Andi Kleen hast written:
> > We discussed this back then with Nvidia engineers and they stated
> > that only NF5 would need timer overrides.
> 
> Can I get a link which verifies your statement? I provided one which kind of 
> contradicts yours.

Sorry cannot supply links to them, they were private mail. For some
reason the Nvidia people seem to be shy to post to mailing lists.

iirc the thread which inspired this patch (together with several
bugs in both novell and kernel.org bugzilla) was 

http://marc.info/?t=116175224500001&r=1&w=2
http://marc.info/?t=116230518000004&r=1&w=2

but you won't find the ultimate conclusion in there unfortunately.

So you have to trust me on that -- it's a bit similar to as to I have
to trust your not yet produced boot log and test results.

-Andi
