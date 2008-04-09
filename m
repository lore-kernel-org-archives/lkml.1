Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbYDIWLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbYDIWLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 18:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYDIWLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 18:11:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50736
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753737AbYDIWLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 18:11:05 -0400
Date: Wed, 09 Apr 2008 15:11:05 -0700 (PDT)
Message-Id: <20080409.151105.145390533.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-04-09
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080409175521.GA5574@tuxdriver.com>
References: <20080409175521.GA5574@tuxdriver.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 9 Apr 2008 13:55:21 -0400

> This request includes everything from the pull request made on
> 2008-04-07, plus two fixes related to interrupts on the SSB bus and a
> mac80211 fix for problems relating to associating with an 802.11b-only
> AP after previously associating with an 802.11g AP.
> 
> Original pull request message (quoted below) still applies.  If for some
> reason you only want the original set of patches, you can pull the
> 'master-2008-04-07' branch instead.

Pulled and pushed out to net-2.6, thanks!
