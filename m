Return-Path: <linux-kernel-owner+w=401wt.eu-S1759803AbZJIA4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803AbZJIA4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 20:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZJIAz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 20:55:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58013
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753846AbZJIAz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 20:55:58 -0400
Date: Thu, 08 Oct 2009 17:55:53 -0700 (PDT)
Message-Id: <20091008.175553.139810708.davem@davemloft.net>
To: mb@bu3sch.de
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-10-08
From: David Miller <davem@davemloft.net>
In-Reply-To: <200910090116.46513.mb@bu3sch.de>
References: <20091008223454.GB2798@tuxdriver.com>
	<200910090108.08838.mb@bu3sch.de>
	<200910090116.46513.mb@bu3sch.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Buesch <mb@bu3sch.de>
Date: Fri, 9 Oct 2009 01:16:44 +0200

> And there's no reason to rush this fix into mainline.

I think it's worthwhile because people turn the DMA API debugger on
and it's going to spit out warnings that "don't matter" until you guys
fix this.

I looked at the patch you guys are so up in arms about, and frankly it
looks perfectly fine to me.

If you want to implement the fix "perfectly", and "to your standards",
then fine.  But do it in net-next-2.6 as a follow-on patch to this
one.

I'm not undoing John's pull request just for this. :-)
