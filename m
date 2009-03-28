Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbZC1Ux5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbZC1Ux5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 16:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbZC1Uxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 16:53:47 -0400
Received: from genesysrack.ru ([195.178.208.66]:54339 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbZC1Uxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 16:53:47 -0400
Date: Sat, 28 Mar 2009 23:53:36 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Stanley.Miao" <stanley.miao@windriver.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [PATCH 31/58] move omap_hdq's probe function to .devinit.text
Message-ID: <20090328205336.GA10393@ioremap.net>
References: <20090327232153.GA16348@pengutronix.de> <1238196439-16535-31-git-send-email-u.kleine-koenig@pengutronix.de> <20090328082148.GA20668@ioremap.net> <20090328193702.GB5588@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090328193702.GB5588@pengutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe.

On Sat, Mar 28, 2009 at 08:37:02PM +0100, Uwe Kleine-König (u.kleine-koenig@pengutronix.de) wrote:
> Maybe you cannot really hotplug it, but with CONFIG_HOTPLUG you can
> unbind it via sysfs and rebind it afterwards, too.
> 
> Can I consider this an Acked-by: you?

Yes, sure.
Thank you.

-- 
	Evgeniy Polyakov
