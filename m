Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbZK3MRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbZK3MRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 07:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbZK3MRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 07:17:39 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:42646 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbZK3MRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 07:17:38 -0500
Date: Mon, 30 Nov 2009 13:17:44 +0100
From: Andreas Mohr <andi@lisas.de>
To: David Miller <davem@davemloft.net>
Cc: zambrano@broadcom.com, dave@thedillows.org, mb@bu3sch.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] b44.c box lockup fix (netconsole): ratelimit NAPI poll
	error message
Message-ID: <20091130121744.GA28479@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130.001541.134590904.davem@davemloft.net>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

now managed to see the replies, thanks for the notification Michael!
(I'm afraid our SMTP trap won't get lifted since it's probably
justified given the SPAM situation).

> The patch below is what I'll check in to fix this, thanks.

Seems fine.

> I'll queue this b44 patch up for -stable too.

Dito.

Thank you very much,

Andreas Mohr
