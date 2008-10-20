Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbYJTE0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbYJTE0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 00:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYJTE0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 00:26:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51388
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752070AbYJTE0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 00:26:22 -0400
Date: Sun, 19 Oct 2008 21:25:59 -0700 (PDT)
Message-Id: <20081019.212559.193693268.davem@davemloft.net>
To: swivel@shells.gnugeneration.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Honoring SO_RCVLOWAT in proto_ops.poll methods
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081020035819.GG2811@fc6222126.aspadmin.net>
References: <20081013083214.GN2811@fc6222126.aspadmin.net>
	<20081013.025816.197282812.davem@davemloft.net>
	<20081020035819.GG2811@fc6222126.aspadmin.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: swivel@shells.gnugeneration.com
Date: Sun, 19 Oct 2008 22:58:19 -0500

> From what I can see the recv() MSG_PEEK fix is trivial anyways, why not
> fix it?

Patches welcome :-)

I'm just very busy and that's the only reason I haven't tackled it
myself.
