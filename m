Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbXJYWgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbXJYWgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 18:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbXJYWga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 18:36:30 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55470 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858AbXJYWg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 18:36:29 -0400
Message-ID: <47211A67.2090201@pobox.com>
Date: Thu, 25 Oct 2007 18:36:23 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Adrian Bunk <bunk@kernel.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, saw@saw.sw.com.sg,
       "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: [2.6.25 patch] the planned eepro100 removal
References: <20071024162440.GN30533@stusta.de> <4720FFAA.9080709@tmr.com>
In-Reply-To: <4720FFAA.9080709@tmr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> Adrian Bunk wrote:
>> This patch contains the planned removal of the eepro100 driver.
>>
> Are the e100 people satisfied that e100 now handles all known cases? I 

Nope.  There are still e100 work outstanding that means we cannot kill 
eepro100.

	Jeff


