Return-Path: <linux-kernel-owner+w=401wt.eu-S1762385AbYDNVKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762385AbYDNVKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 17:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbYDNVJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 17:09:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50235
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754968AbYDNVJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 17:09:54 -0400
Date: Mon, 14 Apr 2008 14:09:55 -0700 (PDT)
Message-Id: <20080414.140955.100207396.davem@davemloft.net>
To: peter.p.waskiewicz.jr@intel.com
Cc: khc@pm.waw.pl, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       jeff@garzik.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] Re: WAN: new PPP code for generic HDLC
From: David Miller <davem@davemloft.net>
In-Reply-To: <D5C1322C3E673F459512FB59E0DDC32904E2B65F@orsmsx414.amr.corp.intel.com>
References: <20080412115950.1cbb9cfa@core>
	<m33apqomgf.fsf@maximus.localdomain>
	<D5C1322C3E673F459512FB59E0DDC32904E2B65F@orsmsx414.amr.corp.intel.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Date: Mon, 14 Apr 2008 12:16:55 -0700

> What I find a bit disturbing is I found my original patchsets I
> submitted to the list that were committed for this patchset.  My
> original patches don't have this change in them at all.  :-(

Ummmm, if you remember we had to put that in because it was the
only way to get your multiqueue changes to even work.

So don't even act as if that got slipped in behind your back,
unknowingly.  You were absolutely informed about this.
