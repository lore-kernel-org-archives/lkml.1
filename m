Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbYHCVBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbYHCVBU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 17:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbYHCVBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 17:01:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38628
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755345AbYHCVBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 17:01:10 -0400
Date: Sun, 03 Aug 2008 14:01:10 -0700 (PDT)
Message-Id: <20080803.140110.151702410.davem@davemloft.net>
To: maxk@qualcomm.com
Cc: linville@tuxdriver.com, linux-kernel@vger.kernel.org
Subject: Re: Circular locking (rtnl_mutex & _xmit_IEEE80211) during suspend
From: David Miller <davem@davemloft.net>
In-Reply-To: <4895FA6F.8050209@qualcomm.com>
References: <4895FA6F.8050209@qualcomm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Krasnyansky <maxk@qualcomm.com>
Date: Sun, 03 Aug 2008 11:35:27 -0700

> Got this lockdep complaint yesterday

Fixed in current GIT.
