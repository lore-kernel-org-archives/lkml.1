Return-Path: <linux-kernel-owner+w=401wt.eu-S1759982AbYDLINn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbYDLINn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 04:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbYDLINa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 04:13:30 -0400
Received: from tim.rpsys.net ([194.106.48.114]:42436 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724AbYDLIN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 04:13:28 -0400
Subject: Re: [patch 2.6.25-rc8] leds: fix platform driver hotplug/coldplug
From: Richard Purdie <rpurdie@rpsys.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <20080411215455.8ccc609c.akpm@linux-foundation.org>
References: <200804111038.34879.david-b@pacbell.net>
	 <20080411215455.8ccc609c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 12 Apr 2008 09:13:06 +0100
Message-Id: <1207987986.4995.0.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-11 at 21:54 -0700, Andrew Morton wrote:
> On Fri, 11 Apr 2008 10:38:34 -0700 David Brownell <david-b@pacbell.net> wrote:
> 
> > From: Kay Sievers <kay.sievers@vrfy.org>
> > 
> > Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform
> > modalias is prefixed with "platform:". Add MODULE_ALIAS() to the
> > hotpluggable platform LED drivers, to re-enable auto loading.
> 
> Richard, I'm pushing as many of these into 2.6.25 as I reasonably can.  A
> swift ack would be good, please.
> 
> Of course, we can always go the backport-it-to-2.6.25.1 route as well. 
> Apparently these problems are also present in 2.6.24.

Acked-by: Richard Purdie <rpurdie@rpsys.net>

Cheers,

Richard

