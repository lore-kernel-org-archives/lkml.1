Return-Path: <linux-kernel-owner+w=401wt.eu-S1946594AbXBIQOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946594AbXBIQOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946599AbXBIQOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:14:25 -0500
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:3848 "EHLO
	outbound1-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946594AbXBIQOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:14:24 -0500
X-BigFish: V
Message-ID: <45CC9DDC.2060305@am.sony.com>
Date: Fri, 09 Feb 2007 08:14:20 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] ps3 usb missed the addition of new argument to	ps3_alloc_io_irq()
References: <E1HFYFg-0004rz-19@ZenIV.linux.org.uk>
In-Reply-To: <E1HFYFg-0004rz-19@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2007 16:14:20.0418 (UTC) FILETIME=[5AEC1E20:01C74C65]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Greg had this same change queued for his usb tree.

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>

