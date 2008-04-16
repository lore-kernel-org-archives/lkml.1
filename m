Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbYDPCUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbYDPCUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 22:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYDPCUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 22:20:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42309
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752812AbYDPCUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 22:20:41 -0400
Date: Tue, 15 Apr 2008 19:20:42 -0700 (PDT)
Message-Id: <20080415.192042.119702071.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-04-15
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080415193857.GA16625@tuxdriver.com>
References: <20080415193857.GA16625@tuxdriver.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 15 Apr 2008 15:38:57 -0400

> This set looks bigger than it really is...three of the patches deal
> with a subtle API change for the SSB bus to do DMA correctly on
> architectures with complex DMA requirements.  The changes in those
> patches amount to applying the same one-line change in dozens of
> places across three drivers (b44, b43, and b43legacy).
> 
> Also included are a number of MAINTAINERS updates.  I guess everyone
> forgets about these until the release nears.
> 
> Finally there are a few minor fixes, like the rfkill fix to only toggle
> state for the correct device type rather than all devices on a system,
> the rtl8187 priv->vif fix, the gelic IE overrun fix, and the mac80211
> fix to limit log SPAM.
> 
> Please let me know if there are problems!  Hopefully this will be the
> last round before 2.6.25...(famous last words...)

Pulled, thanks John.
