Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbYCULpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbYCULpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 07:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbYCULpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 07:45:05 -0400
Received: from ihemail3.lucent.com ([135.245.0.37]:55917 "EHLO
	ihemail3.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbYCULpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 07:45:03 -0400
X-Greylist: delayed 667 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Mar 2008 07:45:03 EDT
Date: Fri, 21 Mar 2008 07:29:27 -0400 (EDT)
Message-Id: <20080321.072927.110651403.pfps@research.bell-labs.com>
To: alan@lxorguk.ukuu.org.uk
Cc: pfps@verizon.net, htejun@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc9-git4: pata_pcmcia, disabling IRQ #9 and Re: libata
 and legacy ide pcmcia failure
From: "Peter F. Patel-Schneider" <pfps@research.bell-labs.com>
In-Reply-To: <20080321111313.24567b9f@core>
References: <20080321104002.27a7d19e@core>
	<47E39963.2090908@verizon.net>
	<20080321111313.24567b9f@core>
X-Mailer: Mew version 5.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Mar 2008 11:33:38.0407 (UTC) FILETIME=[6803AF70:01C88B47]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.23-rc9-git4: pata_pcmcia, disabling IRQ #9 and Re: libata and legacy ide pcmcia failure
Date: Fri, 21 Mar 2008 11:13:13 +0000

>  
> > How can I check to see if this is the case?  How would this explain that 
> 
> As I said before, take a CF card/adapter combination you know fails
> on a T60p/T61p and test it on a Linux box that isn't one of those types
> (and preferably not a Lenovo at all)

Actually I was wondering if there was something that I could do on the
box itself.

> > the adapter and card sometimes work when they are in when the system boots?
> 
> Ask the BIOS authors. Trying to fathom what they have done is frequently
> interesting. Everyone else I've had do this has found the card works
> perfectly with Linux except in the Lenovo box.

I'll investigate further.

> Alan

peter
