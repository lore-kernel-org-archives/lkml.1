Return-Path: <linux-kernel-owner+w=401wt.eu-S1752291AbZL1Xpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbZL1Xpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 18:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbZL1Xpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 18:45:32 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60999 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbZL1Xpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 18:45:31 -0500
Date: Mon, 28 Dec 2009 18:41:56 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Samuel Ortiz <sameo@linux.intel.com>,
       Holger Schurig <holgerschurig@googlemail.com>
Subject: Re: linux-next: manual merge of the net tree with the
	wireless-current tree
Message-ID: <20091228234155.GD13285@tuxdriver.com>
References: <20091229095432.f39a887e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091229095432.f39a887e.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 09:54:32AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in
> drivers/net/wireless/libertas/scan.c between commit
> 659c8e5243caf14564155ad8421404f044dd8031 ("libertas: Remove carrier
> signaling from the scan code") from the wireless-current tree and commit
> 602114ae595af6c89eab149cf9f939e3f7ef4a34 ("libertas: add access functions
> for mesh open/connect status") from the net tree.
> 
> I fixed it up (see below) and can carry the fix for a while.

You have the correct fix.  I'll get this resolved in my trees soon.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
