Return-Path: <linux-kernel-owner+w=401wt.eu-S939056AbYCSWKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939056AbYCSWKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbYCSUeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:34:15 -0400
Received: from rtr.ca ([76.10.145.34]:1627 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933942AbYCSUeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:34:13 -0400
Message-ID: <47E147CD.3060102@rtr.ca>
Date: Wed, 19 Mar 2008 13:05:17 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 6/6] USB: enable USB-PERSIST by default
References: <20080311004239.GD17890@suse.de> <1205197152-18146-6-git-send-email-gregkh@suse.de>
In-Reply-To: <1205197152-18146-6-git-send-email-gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> This patch (as1052) enables USB-PERSIST for all devices by default.
> The user won't have to remember to enable it explicitly for devices
> containing mounted filesystems.
> 
> Eventually userspace tools like hal may be able to set the persist
> attribute automatically when a filesystem is mounted on a USB device.
> When that time comes this patch can be reverted, if people think it
> matters.
..

Should the next word below be "that", rather than "this" ?

> This approach has the advantage of giving the user the ability to turn
> off USB-PERSIST for devices with mounted filesystems, rather than
> making the kernel always assume it should be on.
...

