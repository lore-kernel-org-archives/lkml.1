Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbZIQJ3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbZIQJ3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 05:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754897AbZIQJ3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 05:29:20 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:50881 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbZIQJ3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 05:29:19 -0400
Subject: Re: [PATCH] Voltage count for AB3100 regulator
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <20090917085854.GA18862@sortiz.org>
References: <1253171853-27525-1-git-send-email-linus.walleij@stericsson.com>
	 <20090917085854.GA18862@sortiz.org>
Content-Type: text/plain
Date: Thu, 17 Sep 2009 10:29:20 +0100
Message-Id: <1253179760.5850.3.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 10:58 +0200, Samuel Ortiz wrote:
> Hi Linus,
> 
> On Thu, Sep 17, 2009 at 09:17:33AM +0200, Linus Walleij wrote:
> > This sets the number of voltages for the AB3100 regulators so that
> > they play well with the voltage listing functions and can be used
> > properly with the MMC regulator integration glue for example.
> > 
> > Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> > Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > ---
> > The MFD update containing the AB3100 regulator patch has not yet
> > hit mainline so I guess we'll have to queue this up in Sam's tree
> > too if it's not changing in the next few hours, OK Sam?
> Patch applied.
> I am going to send my pull request to Linus today, yours was the last one I
> take for this merge window.

I'll send my pull request for regulator after mfd is merged. Iirc the
only conflicts are in Kconfig.

Thanks

Liam

