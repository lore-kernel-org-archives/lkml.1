Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbZIWAEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbZIWAEO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 20:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZIWAEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 20:04:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752969AbZIWAEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 20:04:13 -0400
Date: Tue, 22 Sep 2009 17:02:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: avorontsov@ru.mvista.com
Cc: cbouatmailru@gmail.com, dwmw2@infradead.org, david-b@pacbell.net,
       ben@fluff.org, grant.likely@secretlab.ca, benh@kernel.crashing.org,
       khali@linux-fr.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/6] mtd: m25p80: Convert to device table matching
Message-Id: <20090922170215.b5c2d02c.akpm@linux-foundation.org>
In-Reply-To: <20090922235534.GA3796@oksana.dev.rtsoft.ru>
References: <20090731003957.GA23982@oksana.dev.rtsoft.ru>
	<20090731004100.GB8371@oksana.dev.rtsoft.ru>
	<200908031954.50955.david-b@pacbell.net>
	<20090922141705.b5d31e24.akpm@linux-foundation.org>
	<20090922230150.GA27593@oksana.dev.rtsoft.ru>
	<1253663027.27055.528.camel@macbook.infradead.org>
	<20090922235534.GA3796@oksana.dev.rtsoft.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 03:55:34 +0400
Anton Vorontsov <cbouatmailru@gmail.com> wrote:

> On Tue, Sep 22, 2009 at 04:43:47PM -0700, David Woodhouse wrote:
> > On Wed, 2009-09-23 at 03:01 +0400, Anton Vorontsov wrote:
> > > 
> > > And the two patches I sent on top:
> > > 
> > > http://lkml.org/lkml/2009/8/18/364
> > > http://lkml.org/lkml/2009/8/18/366
> > 
> > Got versions of those which apply to the mtd-2.6.git tree (which I'm
> > about to ask Linus to pull)? 
> 
> I'd love to, but they depend on a bunch of SPI patches that are still
> in -mm tree.

oh, is that why I queued them up where I did.  Sigh.

> As soon as SPI core changes hit Linus' tree, I think
> Andrew will send all m25p80 patches to you anyway.

Or David can ack them and I'll send 'em up.
