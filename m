Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab0CBXCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:02:49 -0500
Received: from gir.skynet.ie ([193.1.99.77]:51903 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab0CBXCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:02:48 -0500
Date: Tue, 2 Mar 2010 23:02:31 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm request 2
In-Reply-To: <alpine.LFD.2.00.1003021451130.3616@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1003022300320.4099@skynet.skynet.ie>
References: <alpine.DEB.2.00.1003012345440.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003021451130.3616@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > x86 after PPC (I think I just validated Ingo).
> 
> Why is VGA_SWITCHEROO enabled by default?

because it does nothing on anything except the laptops in question and on 
those it does nothing except add a control file in debugfs?

So how am I supposed to indicate to distro vendors that something should 
be turned on? If you think that distro kernel maintainers really 
understand every config option that goes past, I've got a bridge.

Dave.

