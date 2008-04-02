Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbYDBPtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbYDBPtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 11:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbYDBPti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 11:49:38 -0400
Received: from rtr.ca ([76.10.145.34]:4366 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbYDBPth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 11:49:37 -0400
Message-ID: <47F3AB10.1000708@rtr.ca>
Date: Wed, 02 Apr 2008 11:49:36 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Pavel Machek <pavel@suse.cz>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, jikos@suse.cz,
       linux-usb@vger.kernel.org
Subject: Re: 2.6.25-rc7:  Ugh. ---> PATCH
References: <Pine.LNX.4.44L0.0804021106320.6272-100000@iolanthe.rowland.org> <47F3A9C3.7030702@rtr.ca> <47F3AA97.1010704@rtr.ca>
In-Reply-To: <47F3AA97.1010704@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Mark Lord wrote:
>> This patch seems to fix it.
>> Could you guys look this over some more,
>> as I really am not familiar with the USB code.
> 
> Here it is again, with more lines of context, for easier review:
..

Nope.  Nevermind.

Just got lucky once, without the resistor installed on USB power.

The patch doesn't fix it.  But that code still looks strange to me.

Cheers
