Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbYKYXBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbYKYXBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 18:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYKYXBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 18:01:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46427
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752121AbYKYXBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 18:01:03 -0500
Date: Tue, 25 Nov 2008 15:01:01 -0800 (PST)
Message-Id: <20081125.150101.153225254.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-11-25
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081125220824.GB25962@tuxdriver.com>
References: <20081125220824.GB25962@tuxdriver.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 25 Nov 2008 17:08:24 -0500

> These fixes are intended for 2.6.28.  Included are a build fix,
> a security issue (debugfs permissions), a fixup to a previous patch
> from Johannes to correct some DMA API usage, a fix to prevent mac80211
> from allowing the use of IBSS mode on channels that don't allow it,
> an ath5k fix to limit wakeups when not associate, and some ath9k DMA
> fixes for a problem that led to disk corruption...
> 
> Please let me know if there are problems!

Pulled, thanks a lot John.
