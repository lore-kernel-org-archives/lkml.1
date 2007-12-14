Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbXLNTwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbXLNTwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762633AbXLNTvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:51:24 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41608 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929AbXLNTvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:51:21 -0500
Date: Fri, 14 Dec 2007 19:51:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean Delvare <khali@linux-fr.org>
Cc: eric miao <eric.y.miao@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: READ THIS NOW *BEFORE* RESPONDING TO THIS THREAD --> [PATCH 0/2] gpiolib: add support for PCA9539
Message-ID: <20071214195104.GF15161@flint.arm.linux.org.uk>
References: <f17812d70712100137h3aa0056bq78b0efb92d072891@mail.gmail.com> <20071214171646.0fe5a876@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214171646.0fe5a876@hyperion.delvare>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 05:16:46PM +0100, Jean Delvare wrote:
> Hi Eric,
> 
> On Mon, 10 Dec 2007 17:37:05 +0800, eric miao wrote:
> > Support for PCA9539 as a GPIO chip is separated into two patches:
> > 
> > 0001 - gpiolib: basic support for 16-bit PCA9539 GPIO expander
> > 0002 - gpiolib: add Generic IRQ support for 16-bit PCA9539 GPIO expander
> > 
> > the 2nd one uses workqueue for IRQ handling due to the interrupt mode
> > nature of the i2c-core, thus making it a separate patch.
> 
> Note that the situation could change according to the discussion in
> this thread:
> http://lists.lm-sensors.org/pipermail/i2c/2007-December/002378.html

I'm afraid to have to say this, but your message (with its broken CC
header) has caused several people to be unsubscribed from this mailing
list.

The reason seems to be that the list expander rejected your message,
which causes bounces to be sent back to mailman for a _ton_ of people.

Strangely enough, I run the exact same check ("headers_syntax") on all
messages the list server receives, and when I test it with your message,
it correctly rejects it.  Yet somehow it didn't earlier.  No idea.

In any case, EVERYONE, please drop the invalid "David," in the CC list.
