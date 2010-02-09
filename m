Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab0BIDZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 22:25:27 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47819 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab0BIDZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 22:25:25 -0500
Date: Mon, 8 Feb 2010 22:20:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: linux-next: manual merge of the net tree with the
 wireless-current tree
Message-ID: <20100209032044.GA3397@tuxdriver.com>
References: <20100209132444.d90b48a6.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100209132444.d90b48a6.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 09, 2010 at 01:24:44PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> net/mac80211/scan.c between commit
> c0ce77b8323c1a0d4eeef97caf16c0ea971222a9 ("mac80211: fix deferred
> hardware scan requests") from the wireless-current tree and commit
> af6b63741cc4e4dfd575d06beb333b11a8a6e0c0 ("mac80211: generalise work
> handling") from the net tree.
> 
> I resolved this the same way it is resolved in the merge of the
> wireless-current tree into the wireless tree.

Maybe it would make sense to pull the wireless trees _before_ the
greater net trees?  That way you can get the benefit of my merge
conflict resolutions automatically.

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
