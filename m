Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbYKTMFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbYKTMFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 07:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbYKTMFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 07:05:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60177
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752700AbYKTMFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 07:05:07 -0500
Date: Thu, 20 Nov 2008 04:05:07 -0800 (PST)
Message-Id: <20081120.040507.127347702.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: pull request: wireless-2.6 2008-11-18
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081119000719.GA19756@tuxdriver.com>
References: <20081119000719.GA19756@tuxdriver.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 18 Nov 2008 19:07:19 -0500

> Three fixes from Johannes, intended for 2.6.28...  One fixes a 32/64
> issue in libertas_tf, another removes a mac80211 callback only used
> by iwlwifi which is not obviously needed and which is causing locking
> issues, and a final one fixes some mysterious DMA alignment problems
> that have been plaguing iwlwifi for some time.
> 
> Please let me know if there are problems!

Pulled, thanks John.
