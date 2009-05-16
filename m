Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbZEPUdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbZEPUdt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 16:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbZEPUdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 16:33:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45305
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278AbZEPUdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 16:33:35 -0400
Date: Sat, 16 May 2009 13:33:33 -0700 (PDT)
Message-Id: <20090516.133333.92480462.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-05-12
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090512145423.GA3773@tuxdriver.com>
References: <20090512145423.GA3773@tuxdriver.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 12 May 2009 10:54:24 -0400

> Another round of fixes intended for 2.6.30.  In particular, "mac80211:
> avoid NULL ptr deref when finding max_rates in PID and minstrel" fixes a
> bug that is a by-product of a fix that has already gone to Linus...oops!
> As for the others, the iwlwifi patch adds PCI IDs and corrects antenna
> configurations for a couple of devices, the rtl8187 corrects a problem
> some people were hitting relating to using non-DMA buffers for USB
> messages, the airo fix corrects an possible buffer overflow, and the
> ath5k fix documents the oops it is correcting.

Pulled, Thanks John.  I'll try to get this to Linus over the
weekend.
