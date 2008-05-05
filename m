Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbYEETjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbYEETjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYEETjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:39:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35458
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751862AbYEETjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:39:08 -0400
Date: Mon, 05 May 2008 12:39:08 -0700 (PDT)
Message-Id: <20080505.123908.238254784.davem@davemloft.net>
To: bunk@kernel.org
Cc: jeremy.fitzhardinge@citrix.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] sparc64: remove online_page()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080505182336.GH17139@cs181133002.pp.htv.fi>
References: <20080505182336.GH17139@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Mon, 5 May 2008 21:23:36 +0300

> The identical online_page() implementations from all architectures got 
> moved to mm/memory_hotplug.c - except for the sparc64 one that even was 
> dead code due to MEMORY_HOTPLUG not being available there.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied, thanks Adrian.
