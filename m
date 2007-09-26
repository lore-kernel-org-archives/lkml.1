Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbXIZISK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbXIZISK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 04:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbXIZIR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 04:17:58 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:37106 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbXIZIR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 04:17:57 -0400
To: greg@kroah.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <20070926024121.GA28124@kroah.com> (message from Greg KH on Tue,
	25 Sep 2007 19:41:21 -0700)
Subject: Re: subsystem_unregister() breakage in -mm
References: <E1IaIs6-00051t-00@dorka.pomaz.szeredi.hu> <20070925225330.GA26235@kroah.com> <E1IaJQL-00053O-00@dorka.pomaz.szeredi.hu> <20070926024121.GA28124@kroah.com>
Message-Id: <E1IaS5Z-0005LX-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 26 Sep 2007 10:17:45 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > BUG: failure at mm/slab.c:591/page_get_cache()!
> > Kernel panic - not syncing: BUG!
> 
> Ok, here's a patch that fixes this for me.  It should go on top of the
> -mm tree.  Let me know of this works or not.

Yes, it works for me too.  Thanks.

Miklos
