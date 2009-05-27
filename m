Return-Path: <linux-kernel-owner+w=401wt.eu-S1762923AbZE0Xw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762923AbZE0Xw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762032AbZE0XwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:52:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53598
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757141AbZE0XwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:52:18 -0400
Date: Wed, 27 May 2009 16:52:17 -0700 (PDT)
Message-Id: <20090527.165217.52725949.davem@davemloft.net>
To: r.schwebel@pengutronix.de
Cc: grant.likely@secretlab.ca, timur@freescale.com, yuan-bo.ye@motorola.com,
       devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, rmk@arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090527234801.GP6805@pengutronix.de>
References: <20090527162000.GM6805@pengutronix.de>
	<fa686aa40905271335o1165419hda2334bef42aa3f@mail.gmail.com>
	<20090527234801.GP6805@pengutronix.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Schwebel <r.schwebel@pengutronix.de>
Date: Thu, 28 May 2009 01:48:01 +0200

> My impression is that oftree only works in a perfect world. But we
> don't have one, so the fundamental design decision is broken.

It is imperfect, that's why it all determined by software we
control and thus we can fix.  _THAT_ is the whole point.

Bringing up SMSC over and over again is just a scarecrow.  So
one driver went insanely bad and if an ifdef platform specific
hacks nightmare, big deal.

That has no bearing on whether OF device trees constructed by
bootloader software or onboard firmware is a good idea or not.
