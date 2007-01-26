Return-Path: <linux-kernel-owner+w=401wt.eu-S1030796AbXAZIfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030796AbXAZIfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 03:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030816AbXAZIfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 03:35:16 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:43655 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030796AbXAZIfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 03:35:14 -0500
Message-ID: <45B9BD40.4000708@garzik.org>
Date: Fri, 26 Jan 2007 03:35:12 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [rft] r8169: merge release 6.001.00 of Realtek's driver - take
 #1
References: <20070124231719.GA10010@electric-eye.fr.zoreil.com>
In-Reply-To: <20070124231719.GA10010@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:
> Untested, straight from the "release early" dept. You have been warned.
> 
> Realtek's driver restricts itself to 0x8169 and 0x8167.
> It won't be surprising if it breaks on anything else until
> I merge the new 0x8168 and 0x8136 bits.
> 
> Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

FWIW I would like to see if we can train RealTek to directly submit 
kernel patches, and try to mentor them into helping you maintain the 
RealTek stuff.

	Jeff



