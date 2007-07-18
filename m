Return-Path: <linux-kernel-owner+w=401wt.eu-S1762357AbXGRUJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762357AbXGRUJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbXGRUJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:09:03 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:36933
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbXGRUJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:09:00 -0400
Message-ID: <469E825A.9060408@microgate.com>
Date: Wed, 18 Jul 2007 15:12:58 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: James Simmons <jsimmons@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>
Subject: Re: [PATCH] Use tty_schedule in VT code.
References: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org>  <alpine.LFD.0.999.0707171222060.27353@woody.linux-foundation.org>  <469D2810.9080109@microgate.com>  <alpine.LFD.0.999.0707171243220.27353@woody.linux-foundation.org>  <Pine.LNX.4.64.0707172050180.9131@pentafluge.infradead.org>  <alpine.LFD.0.999.0707171340360.27353@woody.linux-foundation.org>  <Pine.LNX.4.64.0707181821150.28741@pentafluge.infradead.org> <1184783279.3444.15.camel@x2.microgate.com> <Pine.LNX.4.64.0707182056170.28741@pentafluge.infradead.org>
In-Reply-To: <Pine.LNX.4.64.0707182056170.28741@pentafluge.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Simmons wrote:
> Done. I still smell a dead lock issue tho.

Yes, but it is an existing problem that was kicked
about with no real resolution.

No one can blame you for that! :-)

-- 
Paul Fulghum
Microgate Systems, Ltd.
