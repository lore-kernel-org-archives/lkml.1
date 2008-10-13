Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbYJMGwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbYJMGwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 02:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbYJMGw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 02:52:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60640
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753108AbYJMGw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 02:52:28 -0400
Date: Sun, 12 Oct 2008 23:52:04 -0700 (PDT)
Message-Id: <20081012.235204.37529445.davem@davemloft.net>
To: mingo@elte.hu
Cc: netdev@vger.kernel.org, linville@tuxdriver.com, davidepesa@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: net/mac80211/rx.c: fix build error
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081013064135.GA19719@elte.hu>
References: <20081013064135.GA19719@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 13 Oct 2008 08:41:35 +0200

> 
> FYI, the fixlet below is still needed, even after b0dee578 ("Fix modpost 
> failure when rx handlers are not inlined."). The build error triggered 
> on a -tip testbox.

Fair enough, applied, thanks.
