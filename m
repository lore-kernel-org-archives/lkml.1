Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbZGAUrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbZGAUrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 16:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZGAUrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 16:47:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53628
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbZGAUrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 16:47:23 -0400
Date: Wed, 01 Jul 2009 13:47:29 -0700 (PDT)
Message-Id: <20090701.134729.13610576.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] ide: allow ide_dev_read_id() to be called from the
 IRQ context
From: David Miller <davem@davemloft.net>
In-Reply-To: <200907011835.27586.bzolnier@gmail.com>
References: <20090624.025518.75726622.davem@davemloft.net>
	<200906241248.21173.bzolnier@gmail.com>
	<200907011835.27586.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Wed, 1 Jul 2009 18:35:27 +0200

> On Wednesday 24 June 2009 12:48:20 Bartlomiej Zolnierkiewicz wrote:
>> On Wednesday 24 June 2009 11:55:18 David Miller wrote:
> 
> [...]
> 
>> > I know you're busy, so I'll try to draft something up myself.
>> 
>> Ok, thanks.
> 
> Any news about these fixes?

Will get to it before the end of the weekend.

If I fail or abort, I'll integrate your version of the fix Bart, don't
worry :)
