Return-Path: <linux-kernel-owner+w=401wt.eu-S1759980AbYD3HTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980AbYD3HTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbYD3HTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:19:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49159
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754967AbYD3HTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:19:11 -0400
Date: Wed, 30 Apr 2008 00:19:10 -0700 (PDT)
Message-Id: <20080430.001910.242791438.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com
Subject: Re: sparc64 bootup regression...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080429233832.168fb6ee.akpm@linux-foundation.org>
References: <20080429.231241.221824292.davem@davemloft.net>
	<20080429233832.168fb6ee.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 29 Apr 2008 23:38:32 -0700

> Does a straightforward revert fix it?

Yes.

> If so, we could do that while heads are being scratched.

I want to make a note to everyone that this is the first time this
whole merge window that someone who submitted a regression causing
commit even remotely suggested that it be reverted.

I think Andrew should be commended.

This is tons better than the "revert?  no way, that makes me look bad
and makes more work for me!"  methodology that others seem to
subscribe to.
