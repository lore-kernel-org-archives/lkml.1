Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbYAQBBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbYAQBBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 20:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYAQBAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 20:00:47 -0500
Received: from rtr.ca ([76.10.145.34]:4657 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbYAQBAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 20:00:46 -0500
Message-ID: <478EA8BA.7080700@rtr.ca>
Date: Wed, 16 Jan 2008 20:00:42 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux RAID list <linux-raid@vger.kernel.org>,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: The SX4 challenge
References: <478EA794.8080608@garzik.org>
In-Reply-To: <478EA794.8080608@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
..
> Thus, the "SX4 challenge" is a challenge to developers to figure out the 
> most optimal configuration for this hardware, given the existing MD and 
> DM work going on.
..

This sort of RAID optimization hardware is not unique to the SX4,
so hopefully we can work out a way to take advantage of similar/different
RAID throughput features of other chipsets too (eventually).

This could be a good topic for discussion/beer in San Jose next month..

Cheers
