Return-Path: <linux-kernel-owner+w=401wt.eu-S1751618AbZIWQkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbZIWQkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 12:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbZIWQkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 12:40:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35761 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750769AbZIWQkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 12:40:04 -0400
Date: Wed, 23 Sep 2009 17:40:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [RFC] regulator: add driver for MAX8660/8661
Message-ID: <20090923164007.GC31134@opensource.wolfsonmicro.com>
References: <1253625499-9314-1-git-send-email-w.sang@pengutronix.de> <20090922191529.GB4690@sirena.org.uk> <20090923151538.GD3131@pengutronix.de> <20090923160556.GA8593@sirena.org.uk> <20090923161340.GE3131@pengutronix.de> <20090923162547.GA31134@opensource.wolfsonmicro.com> <20090923162922.GF3131@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923162922.GF3131@pengutronix.de>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 06:29:22PM +0200, Wolfram Sang wrote:
> > Normally things like that would be fixed by the hardware design and set
> > once at system startup - the core doesn't have any support for
> > configuring this stuf at present.

> So, another pdata-option I assume?

Yes, or just leave it alone until someone needs it (but it should be
simple enough to implement and you already have the platform data).
