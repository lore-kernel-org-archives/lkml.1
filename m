Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbZGVOQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbZGVOQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 10:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbZGVOQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 10:16:03 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54386 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993AbZGVOQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:16:01 -0400
Date: Wed, 22 Jul 2009 10:03:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
       Christian Lamparter <chunkeey@web.de>
Subject: Re: linux-next: manual merge of the net tree with the
	wireless-current tree
Message-ID: <20090722140351.GC5276@tuxdriver.com>
References: <20090722120000.4b0f2901.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090722120000.4b0f2901.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 12:00:00PM +1000, Stephen Rothwell wrote:
> Hi David,
> 
> Today's linux-next merge of the net tree got a conflict in
> net/wireless/scan.c between commit
> 9e81eccf199d910e5ea8db377a43478e4eccd033 ("cfg80211: double free in
> __cfg80211_scan_done") from the wireless-current tree and commit
> 667503ddcb96f3b10211f997fe55907fa7509841 ("cfg80211: fix locking") from
> the net tree.
> 
> Overlapping additions.  I fixed it up (I think - see below) and can carry
> the fix as ncessary.

Looks fine, thanks!

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
