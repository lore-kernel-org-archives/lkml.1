Return-Path: <linux-kernel-owner+w=401wt.eu-S1760946AbZJMSmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946AbZJMSmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760087AbZJMSmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:42:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49312
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754156AbZJMSmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:42:10 -0400
Date: Tue, 13 Oct 2009 11:42:06 -0700 (PDT)
Message-Id: <20091013.114206.00578027.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-10-13
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091013150558.GC2747@tuxdriver.com>
References: <20091013150558.GC2747@tuxdriver.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 13 Oct 2009 11:05:58 -0400

> Here are a few (almost-)one-liners for 2.6.32.  Included are fixes for
> a use-after-free, a missing "!" in front of a memcmp when comparing
> BSSIDs, a race when using hardware-based scanning, the ieee80211_rx
> context problem, a related documentation change, and a minor build
> issue.
> 
> Please let me know if there are problems!

Pulled, thanks a lot!
