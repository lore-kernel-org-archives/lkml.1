Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbYKJRUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbYKJRUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 12:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbYKJRUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 12:20:22 -0500
Received: from matrixpower.ru ([195.178.208.66]:59139 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754094AbYKJRUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 12:20:21 -0500
Date: Mon, 10 Nov 2008 20:20:18 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: mtk.manpages@gmail.com
Cc: linux-kernel@vger.kernel.org, Robert Love <rlove@rlove.org>,
       linux-api@vger.kernel.org, John McCutchan <ttb@tentacle.dhs.org>
Subject: Re: [1/1] Use pid in inotify events.
Message-ID: <20081110172018.GA22332@ioremap.net>
References: <20081108114225.GA22674@ioremap.net> <cfd18e0f0811080625w5b285cc0p2410e8d187b025c7@mail.gmail.com> <20081108153545.GA3859@ioremap.net> <cfd18e0f0811080858k7f6cddadg962771ed0cb3bdb8@mail.gmail.com> <20081110152043.GB15796@ioremap.net> <cfd18e0f0811100915o8ea98a0s816921cee3163c1c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd18e0f0811100915o8ea98a0s816921cee3163c1c@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 12:15:36PM -0500, Michael Kerrisk (mtk.manpages@googlemail.com) wrote:
> > This may be a good idea for some serious ABI change. I think we could
> > extend it even more to include IO offset/size into events and attribute
> > changes.
> 
> Are you going to revise your patch to use this idea?

Not now, since it is not a two-minute hack to write on top of existing
interfaces :)

-- 
	Evgeniy Polyakov
