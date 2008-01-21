Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbYAUXB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbYAUXB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbYAUXBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:01:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:19431 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbYAUXBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:01:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=ggqHliadgDIQuzKPBsXX5hp2DvH1WDHEhTm9/Yv2M8rZ32FPld8YDCeifN2doCRfMZwwyIXMTiMxbCJVpSMJ0fubCl8vzSKHT10RY/9plQl6JuEb/eoOSl2K2A4ykTkgP01/YivSH9i+JQDNaJT9c4N74dbpPyB9aoSHg2o5jJ0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: bbpetkov@yahoo.de
Subject: Re: [PATCH 0/12] ide-floppy redux v2.5
Date: Mon, 21 Jan 2008 23:45:35 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de> <200801142238.17282.bzolnier@gmail.com> <20080120123815.GA20082@gollum.tnic>
In-Reply-To: <20080120123815.GA20082@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801212345.35762.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Borislav,

On Sunday 20 January 2008, Borislav Petkov wrote:
> On Mon, Jan 14, 2008 at 10:38:17PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > > By the way, I have an Iomega ZIP 100 drive somewhere in my hardware pile and
> > > will do some testing with the "new" :) driver just in case.
> > 
> > This would be great. :)
> Hi Bart,
> 
> i just whipped rc8 along with your pata-2.6 tree on top and had several test
> runs of the ide-floppy driver (raw reads, software floppy disk eject, etc) and
> everything seems to work fine. I will keep this hardware setup here so that we
> could at least test ide-floppy occasionally. We should probably acknowledge this

Big thanks for all great ide-floppy work!  I hope that you'll continue with
putting IDE device drivers in shape. :)

> major driver cleanup with a new driver version?

Yep.

> ---
> From 6f948b93839cdf397cb38ca75c3c6cc9a21e6070 Mon Sep 17 00:00:00 2001
> From: Borislav Petkov <bbpetkov@yahoo.de>
> Date: Sun, 20 Jan 2008 13:32:24 +0100
> Subject: [PATCH] ide-floppy: bump driver version number
> 
> Acknowledge major ide-floppy code refactoring and cleanup by bumping the driver
> version number. Also, remove a wrong comment.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

applied
