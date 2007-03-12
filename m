Return-Path: <linux-kernel-owner+w=401wt.eu-S1030357AbXCLPN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030357AbXCLPN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030371AbXCLPN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:13:56 -0400
Received: from rtr.ca ([64.26.128.89]:1447 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030357AbXCLPNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:13:55 -0400
Message-ID: <45F56E37.9050506@rtr.ca>
Date: Mon, 12 Mar 2007 11:13:59 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
Cc: Adrian Bunk <bunk@stusta.de>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG} usb-serial regression in 2.6.21-rc2-git3
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <45EB9DC6.8010403@rtr.ca> <45F56A2D.9010808@rtr.ca> <200703121606.06601.oneukum@suse.de>
In-Reply-To: <200703121606.06601.oneukum@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Montag, 12. März 2007 15:56 schrieb Mark Lord:
>> Still no improvement on the b0rken usb-serial resume support in -rc*.
> 
> Have you applied the fixes in Greg's current tree?

I don't know anything about any "current tree"
other than the 2.6.21-rc3-git* on kernel.org.

Greg hasn't suggested anything for this yet,
mostly because he's been busy keeping the 2.6.20.xx
point releases sane.

Cheers
