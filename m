Return-Path: <linux-kernel-owner+w=401wt.eu-S965039AbXBUCca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965039AbXBUCca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 21:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965113AbXBUCca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 21:32:30 -0500
Received: from elvis.mu.org ([192.203.228.196]:51525 "EHLO elvis.mu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965039AbXBUCc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 21:32:29 -0500
X-Greylist: delayed 1093 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Feb 2007 21:32:29 EST
In-Reply-To: <200702210244.53514.bzolnier@gmail.com>
References: <20070221011922.GA1777@freefall.freebsd.org> <200702210244.53514.bzolnier@gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <3063A690-4E3D-4A6E-A7DC-3E624121FBB8@freebsd.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Suleiman Souhlal <ssouhlal@freebsd.org>
Subject: Re: [PATCH 1/3] Make the IDE DMA timeout modifiable
Date: Tue, 20 Feb 2007 18:13:53 -0800
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 20, 2007, at 5:44 PM, Bartlomiej Zolnierkiewicz wrote:

>
> On Wednesday 21 February 2007 02:19, Suleiman Souhlal wrote:
>> It can be changed via /proc/ide/hd?/settings.
>
> Why do we need to change IDE DMA timeout dynamically?

I've used it to test error recovery (for example).

> BTW /proc/ide/hd?/settings is obsoleted

What's the preferred way of changing such settings, these days?

-- Suleiman


