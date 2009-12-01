Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbZLAOPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbZLAOPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 09:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZLAOPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 09:15:37 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52978 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbZLAOPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 09:15:36 -0500
Date: Tue, 1 Dec 2009 09:06:58 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: linux-next: manual merge of the net tree with the
	wireless-current tree
Message-ID: <20091201140658.GA11031@tuxdriver.com>
References: <20091201123142.fe6bc824.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201123142.fe6bc824.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 12:31:42PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in net/mac80211/ht.c between commit 827d42c9ac91ddd728e4f4a31fefb906ef2ceff7 ("mac80211: fix spurious delBA handling") from the wireless-current tree and commit c951ad3550ab40071bb0f222ba6125845769c08a ("mac80211: convert aggregation to operate on vifs/stas") from the net tree.
> 
> I fixed it up (by using the version from the wireless-current tree) and
> can carry the fix as necessary.  This may well not be correct.

That sounds like the correct fix...thanks!

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
