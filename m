Return-Path: <linux-kernel-owner+w=401wt.eu-S932204AbYENMvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbYENMvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 08:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758232AbYENMuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 08:50:52 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4185 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758015AbYENMuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 08:50:51 -0400
Date: Wed, 14 May 2008 08:34:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ron.rindjunsky@intel.com, sfr@canb.auug.org.au, tomas.winkler@intel.com,
       git@vger.kernel.org
Subject: Re: + wireless-fix-iwlwifi-unify-init-driver-flow.patch added to
	-mm tree
Message-ID: <20080514123432.GB3349@tuxdriver.com>
References: <200805140405.m4E45oBc015343@imap1.linux-foundation.org> <20080513.213927.191790810.davem@davemloft.net> <20080513215737.fe1bdebd.akpm@linux-foundation.org> <20080513.221529.20855966.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513.221529.20855966.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 10:15:29PM -0700, David Miller wrote:

> I used to play this game, it's a lot of work and it sucks.  One
> "drib" can require fixing up 200 patches down the chain.  And
> I've had this happen to me all the time in the past when I was
> rebasing all the time.

I have to agree with Dave.

Moreover, I used to get regular complaints about the old "regular
rebase" process.  We switched to a "pull and merge" process for 2.6.25,
and in that period nearly all of the process-related complaints
disappeared for me.

To some degree this is a "pick your poison" issue, and for most people
rebasing seems like the deadlier poison.

John
-- 
John W. Linville
linville@tuxdriver.com
