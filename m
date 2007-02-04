Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbXBDKg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbXBDKg3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 05:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbXBDKg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 05:36:29 -0500
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47865
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbXBDKg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 05:36:28 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: Free Linux Driver Development!
Date: Sun, 4 Feb 2007 11:36:14 +0100
User-Agent: KMail/1.9.5
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>
References: <45C57C93.2020808@lwfinger.net>
In-Reply-To: <45C57C93.2020808@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702041136.15083.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 February 2007 07:26, Larry Finger wrote:
> What is true is that none of the OFDM rates work 
> because of some unknown bug, probably in initialization. As a result, we are limited to a maximum
> data rate of 11Mbs, but it is still running in 802.11g mode!

That's also not true for me. I really don't understand why people keep saying
that rates above 11MBit don't work, because they do (and always did) on all
of my 4306 cards.
Sure, rates above 11M don't work for 4318 and similiar, but for those cards
not even 11M works, so one has to use 1M or something.

And there is absolutely no limit to 11MBit in the code.

-- 
Greetings Michael.
