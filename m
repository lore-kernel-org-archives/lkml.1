Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbXLQM6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbXLQM6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 07:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbXLQM6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 07:58:12 -0500
Received: from styx.suse.cz ([82.119.242.94]:49546 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752591AbXLQM6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:58:11 -0500
Date: Mon, 17 Dec 2007 13:58:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Sterba <dsterba@suse.cz>, linux-kernel@vger.kernel.org,
       linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH V2] ipwireless_cs driver for 4G PC Card
In-Reply-To: <20071217032222.af86c830.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0712171355380.12449@jikos.suse.cz>
References: <20071130125555.GA10977@ds.suse.cz> <20071212150851.GB10118@ds.suse.cz>
 <Pine.LNX.4.64.0712171155130.12449@jikos.suse.cz>
 <20071217032222.af86c830.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007, Andrew Morton wrote:

> > Andrew, what is your position on merging this into your 2.6.25 queue 
> > please? David has fixed all the issues that came up during review, so 
> > it seems to be that it's time for the driver to be merged during the 
> > upcoming merge window. If you take it, I am perfectly fine with you 
> > dropping the ipwireless_cs git tree from -mm lineup.
> I'd have thought that you'd merge it into git-ipwireless_cs.patch and that
> you would then take care of merging it into mainline at an appropriate
> time?

I'd normally send this through PCMCIA maintainer's tree, but as long as 
there is no such thing, I thought that merging through you is the best 
thing to do. I don't want to bother Linus with pull request for a single 
new driver.

Thanks,

-- 
Jiri Kosina
SUSE Labs
