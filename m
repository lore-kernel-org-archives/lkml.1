Return-Path: <linux-kernel-owner+w=401wt.eu-S1752427AbZIWQZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbZIWQZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 12:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbZIWQZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 12:25:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52357 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751296AbZIWQZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 12:25:44 -0400
Date: Wed, 23 Sep 2009 17:25:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [RFC] regulator: add driver for MAX8660/8661
Message-ID: <20090923162547.GA31134@opensource.wolfsonmicro.com>
References: <1253625499-9314-1-git-send-email-w.sang@pengutronix.de> <20090922191529.GB4690@sirena.org.uk> <20090923151538.GD3131@pengutronix.de> <20090923160556.GA8593@sirena.org.uk> <20090923161340.GE3131@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923161340.GE3131@pengutronix.de>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 06:13:40PM +0200, Wolfram Sang wrote:

> > Any references?  I did search the datasheet for at least one of the
> > parts before asking but didn't turn anything up.

> Page 34 mentions it in Register 0x80 and points to the section "Ramp Rate
> Control", page 28f.

Normally things like that would be fixed by the hardware design and set
once at system startup - the core doesn't have any support for
configuring this stuf at present.
