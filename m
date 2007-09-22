Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbXIVReG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbXIVReG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 13:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbXIVRdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 13:33:55 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:50648 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbXIVRdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 13:33:55 -0400
Date: Sat, 22 Sep 2007 10:33:25 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, reiserfs-dev@namesys.com,
       Greg KH <greg@kroah.com>, lepton <ytht.net@gmail.com>
Subject: Re: [stable] [PATCH] 2.6.22.6 fix kernel panic on corrupted
	reiserfs directory
Message-ID: <20070922173325.GD3906@sequoia.sous-sol.org>
References: <20070914101019.GA12437@router.lepton.home> <6101e8c40709141004v57d74eb5hc683901fa267da2b@mail.gmail.com> <20070921224527.GA14632@kroah.com> <6101e8c40709220334v7eefbb8g73128bc315ca07d4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40709220334v7eefbb8g73128bc315ca07d4@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Oliver Pinter (oliver.pntr@gmail.com) wrote:
> it is Lepton's patch.
> Namesys boys, this patch is OK?
> Greg, I neither do find this patch in Linus's tree.

The point is, if it's not important enough to go into Linus' tree, than
it isn't important enough to be in the -stable tree.  So please get this
patch upstream to Linus, then we will take it for -stable.

thanks,
-chris

P.S.  When forwarding someone else's patch, always include the proper
authorship (such as "From: Lepton Wu <ytht.net@gmail.com>" in the first
line of the email body) so that information is not lost.
