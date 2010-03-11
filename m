Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab0CKC6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 21:58:48 -0500
Received: from home.einfach.org ([80.86.92.145]:49052 "EHLO home.einfach.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837Ab0CKC6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 21:58:43 -0500
X-Greylist: delayed 1212 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2010 21:58:43 EST
From: Bruno Randolf <br1@einfach.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the wireless tree with the wireless-current tree
Date: Thu, 11 Mar 2010 11:38:11 +0900
User-Agent: KMail/1.13.1 (Linux/2.6.31-20-generic; KDE/4.4.1; x86_64; ; )
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20100311131500.1057b6c5.sfr@canb.auug.org.au>
In-Reply-To: <20100311131500.1057b6c5.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003111138.12070.br1@einfach.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 March 2010 11:15:00 Stephen Rothwell wrote:
> Hi John,
> 
> Today's linux-next merge of the wireless tree got a conflict in
> drivers/net/wireless/ath/ath5k/phy.c between commit
> 86415d43efd4f7093979cfa8a80232114266f1a4 ("ath5k: fix I/Q calibration
> (for real)") from the wireless-current tree and commit
> 49a85d211a63ad1d565842ebc535c5168d85d86a ("ath5k: IQ calibration for
> AR5211 is slightly different") from the wireless tree.
> 
> I fixed it up (I think - see below) and can carry the fix for a while.

not sure what happened...

but wireless-next-2.6.git 86415d43efd4f7093979cfa8a80232114266f1a4 is an older 
version of my patch. i have sent one which applies cleanly later on.

your fix is correct, though.

bruno
