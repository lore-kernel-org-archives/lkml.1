Return-Path: <linux-kernel-owner+w=401wt.eu-S1751819AbXIPG0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbXIPG0P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 02:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbXIPGZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 02:25:59 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:36121 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbXIPGZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 02:25:58 -0400
Date: Sun, 16 Sep 2007 08:27:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] jumbo all-NICs ethtool count cleanup
Message-ID: <20070916062722.GA5498@uranus.ravnborg.org>
References: <20070916061015.GA11373@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070916061015.GA11373@havoc.gtf.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff.

You wrote:
> The hooks ->self_test_count() and ->get_stats_count() are now unused
> in the main tree.

So I'm suprised to see more lines added than deleted:
>  35 files changed, 346 insertions(+), 246 deletions(-)

Puzzled - may need a bit more coffee (morning here)..

	Sam
