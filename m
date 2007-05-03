Return-Path: <linux-kernel-owner+w=401wt.eu-S1767333AbXECCUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767333AbXECCUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 22:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767330AbXECCUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 22:20:00 -0400
Received: from adsl-216-102-214-42.dsl.snfc21.pacbell.net ([216.102.214.42]:60765
	"EHLO cynthia.pants.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767333AbXECCT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 22:19:59 -0400
Date: Wed, 2 May 2007 19:14:03 -0700
From: Brad Boyer <flar@allandria.com>
To: James Simmons <jsimmons@infradead.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       nubus-pmac-users@lists.sourceforge.net
Subject: Re: [patch 19/33] NuBus header update
Message-ID: <20070503021403.GA22188@cynthia.pants.nu>
References: <20070501203234.252205858@mail.of.borg> <20070501203334.843356635@mail.of.borg> <Pine.LNX.4.64.0705022046180.6403@pentafluge.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705022046180.6403@pentafluge.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 08:47:13PM +0100, James Simmons wrote:
> Will we see nubus ported over to the driver model soon :-)

I think it will happen eventually. However, my first priority
personally is to get the macio code working on non-PCI macs
to get the onboard stuff onto the driver model. I did look at
it, and NuBus does lend itself to this conversion due to the
fact that it does in general have devices that can be detected
at runtime and a lot of generic infrastructure. It's just a
matter of priorities and a lack of time all around.

	Brad Boyer
	flar@allandria.com

