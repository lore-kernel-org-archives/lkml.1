Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbZJBHgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbZJBHgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 03:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbZJBHgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 03:36:22 -0400
Received: from mail.perches.com ([173.55.12.10]:1617 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbZJBHgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 03:36:22 -0400
Subject: Re: Zaurus suspend saga
From: Joe Perches <joe@perches.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Stanislav Brabec <utx@penguin.cz>, Eric Miao <eric.y.miao@gmail.com>,
       Richard Purdie <rpurdie@rpsys.net>, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       Andrea Adami <andrea.adami@gmail.com>
In-Reply-To: <20091002041346.GC1409@ucw.cz>
References: <20090906052653.GB1324@ucw.cz>
	 <1252276145.17852.15.camel@dax.rpnet.com>
	 <f17812d70909061806y651c390w1faa5364f0fb6ddc@mail.gmail.com>
	 <20090907110307.GK23450@elf.ucw.cz>
	 <1252323270.14911.20.camel@hammer.suse.cz>  <20091002041346.GC1409@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Oct 2009 00:36:24 -0700
Message-Id: <1254468984.1799.160.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-02 at 06:13 +0200, Pavel Machek wrote:
> Should I get listed as zaurus maintainer so that I get to see
> zaurus-breaking patches before they hit the mainline?
 
So add a Zaurus section to MAINTAINERS
but maybe make the S: line something like:

S: Not maintained but at least I have hardware...


