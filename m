Return-Path: <linux-kernel-owner+w=401wt.eu-S936612AbXLQUow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936612AbXLQUow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934969AbXLQUoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 15:44:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50089 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936594AbXLQUoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 15:44:30 -0500
Date: Mon, 17 Dec 2007 12:44:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: dsterba@suse.cz, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH V2] ipwireless_cs driver for 4G PC Card
Message-Id: <20071217124408.284886a6.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0712171355380.12449@jikos.suse.cz>
References: <20071130125555.GA10977@ds.suse.cz>
	<20071212150851.GB10118@ds.suse.cz>
	<Pine.LNX.4.64.0712171155130.12449@jikos.suse.cz>
	<20071217032222.af86c830.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0712171355380.12449@jikos.suse.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 13:58:09 +0100 (CET)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Mon, 17 Dec 2007, Andrew Morton wrote:
> 
> > > Andrew, what is your position on merging this into your 2.6.25 queue 
> > > please? David has fixed all the issues that came up during review, so 
> > > it seems to be that it's time for the driver to be merged during the 
> > > upcoming merge window. If you take it, I am perfectly fine with you 
> > > dropping the ipwireless_cs git tree from -mm lineup.
> > I'd have thought that you'd merge it into git-ipwireless_cs.patch and that
> > you would then take care of merging it into mainline at an appropriate
> > time?
> 
> I'd normally send this through PCMCIA maintainer's tree, but as long as 
> there is no such thing, I thought that merging through you is the best 
> thing to do. I don't want to bother Linus with pull request for a single 
> new driver.
> 

Linus will cope ;)

Assuming that you've reviewed the driver and have some understanding of
what it does and how it does it, you're way ahead of me.  Please go ahead
and merge it when you think that is appropriate.  
