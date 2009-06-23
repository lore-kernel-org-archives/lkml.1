Return-Path: <linux-kernel-owner+w=401wt.eu-S1751898AbZFWEQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbZFWEQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 00:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbZFWEQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 00:16:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51906
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750729AbZFWEQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 00:16:03 -0400
Date: Mon, 22 Jun 2009 21:16:06 -0700 (PDT)
Message-Id: <20090622.211606.28120054.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cs5520: add missing IRQ setup for the second port
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906230305.55283.bzolnier@gmail.com>
References: <20090622.163136.246300819.davem@davemloft.net>
	<200906230230.14074.bzolnier@gmail.com>
	<200906230305.55283.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 23 Jun 2009 03:05:55 +0200

> Please give people some time (few days) to review and comment patches before
> applying them.  I don't trust my own patches too much so I'm always looking
> for some peer review (usually all host driver patches go through Sergei, in
> this case Frans would have probably shot the patch down)..

Just because it's in my tree doesn't mean it's on it's way to
Linus yet.

Every patch will sit for at least a day or two until I really
push things to him.  Allowing for such errors to be spotted.

I can easily revert this and that's exactly what I will do.
