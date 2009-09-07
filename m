Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbZIGXWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbZIGXWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 19:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbZIGXWC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 19:22:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55688 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbZIGXWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 19:22:01 -0400
Date: Mon, 7 Sep 2009 20:21:34 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: Staging tree status for the .32 kernel merge
Message-ID: <20090907202134.4feebe6f@caramujo.chehab.org>
In-Reply-To: <20090903041429.GA29875@kroah.com>
References: <20090903041429.GA29875@kroah.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 2 Sep 2009 21:14:30 -0700

> 	- go7007.  Ugh.  Unless someone steps up now to take this over,
> 	  it's going to be removed in .33.  There is no hardware made
> 	  with this anymore, and no specs around that I know of, and the
> 	  code isn't the nicest in the world.

I think nobody will cry if you remove this one. This is an old hardware, and not
manufactured anymore. The chipset of the compression hardware is
obsolete and orphaned, as the audio/video unit were sold to another company.

> 	- udlfb.  Video over USB, it doesn't get anymore whacked than
> 	  that.  This is still being developed but the developer doesn't
> 	  like to do incremental updates for some odd reason.  Hopefully
> 	  he pops up again with an update.  But for now, it is quite
> 	  workable for a number of developers.

Is this a video streaming driver (like other V4L2 drivers) or a video adapter
driver?



Cheers,
Mauro
