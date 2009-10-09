Return-Path: <linux-kernel-owner+w=401wt.eu-S1760124AbZJIBB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbZJIBB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 21:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758353AbZJIBB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 21:01:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54625
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758147AbZJIBBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 21:01:25 -0400
Date: Thu, 08 Oct 2009 18:01:19 -0700 (PDT)
Message-Id: <20091008.180119.242402327.davem@davemloft.net>
To: mb@bu3sch.de
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-10-08
From: David Miller <davem@davemloft.net>
In-Reply-To: <200910090108.08838.mb@bu3sch.de>
References: <20091008223454.GB2798@tuxdriver.com>
	<200910090108.08838.mb@bu3sch.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Buesch <mb@bu3sch.de>
Date: Fri, 9 Oct 2009 01:08:06 +0200

> I was planning to do a better solution, but I didn't have the time, yet.

The change is harmless while we're twiddling our thumbs waiting
for you to implement the fix "properly."

Not having the fix in is a developer burdon because people turn
on the DMA API debugger and are going to keep reporting it's
complaints here and elsewhere.

Get over your Napoleon complex, and let reasonable working fixes
get into the tree even if you don't find them optimal.  You can
always improve them later, "when you get around to it."

People put fixes in without my ACK in my areas of expertiece all
the time.  I got over it a long time ago, it's OK, and not worth
stressing out over.

Thanks.
