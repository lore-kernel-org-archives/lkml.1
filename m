Return-Path: <linux-kernel-owner+w=401wt.eu-S932437AbZE1APp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbZE1APp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 20:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760657AbZE1AP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 20:15:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34847
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755119AbZE1AP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 20:15:26 -0400
Date: Wed, 27 May 2009 17:15:25 -0700 (PDT)
Message-Id: <20090527.171525.204909140.davem@davemloft.net>
To: r.schwebel@pengutronix.de
Cc: scottwood@freescale.com, grant.likely@secretlab.ca,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, yuan-bo.ye@motorola.com,
       timur@freescale.com, rmk@arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090528000707.GR6805@pengutronix.de>
References: <20090527234801.GP6805@pengutronix.de>
	<4A1DD3A0.3010501@freescale.com>
	<20090528000707.GR6805@pengutronix.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Schwebel <r.schwebel@pengutronix.de>
Date: Thu, 28 May 2009 02:07:07 +0200

> Until now, oftree has created more problems than it has solved for us.
> The idea works fine for well-known things like memory maps and
> interrupts.

Here you give a specific example about the positives.

> It works badly for corner cases, and embedded land is full
> of it. The effort to get the oftree stuff right is often more than a
> magnitude of order higher than the effort for the actual functionality.
> That should be an alarm sign that something is wrong.

And here you speak about the negatives purely in generalities that
cannot be discussed concretely.

And, sadly, I think this is on purpose.
