Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYKDHry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYKDHry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 02:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbYKDHrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 02:47:45 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:46630 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbYKDHrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 02:47:45 -0500
Message-ID: <490FFE1A.30606@garzik.org>
Date: Tue, 04 Nov 2008 02:47:38 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Steven Noonan <steven@uplinklabs.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] EHCI pci-quirks.c: wait for BIOS handoff too long
References: <1225774635-15032-1-git-send-email-steven@uplinklabs.net> <490FDE72.9060400@garzik.org> <200811032251.47110.david-b@pacbell.net>
In-Reply-To: <200811032251.47110.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Monday 03 November 2008, Jeff Garzik wrote:
>> That tells us nothing about the original reason for choosing the 5000 
>> value, and what if any impact lowering the value has on those who 
>> thought 5000 was needed.
> 
> You mean, the source code should have a comment about that?

I was thinking changeset description (email body), but source code 
comment works too.

	Jeff



