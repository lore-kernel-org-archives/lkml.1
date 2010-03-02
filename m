Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab0CBXG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:06:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787Ab0CBXG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:06:27 -0500
Date: Tue, 2 Mar 2010 15:06:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@linux.ie>
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm request 2
In-Reply-To: <alpine.DEB.2.00.1003022300320.4099@skynet.skynet.ie>
Message-ID: <alpine.LFD.2.00.1003021505000.3616@localhost.localdomain>
References: <alpine.DEB.2.00.1003012345440.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003021451130.3616@localhost.localdomain> <alpine.DEB.2.00.1003022300320.4099@skynet.skynet.ie>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Mar 2010, Dave Airlie wrote:
> 
> because it does nothing on anything except the laptops in question and on 
> those it does nothing except add a control file in debugfs?

It's still code. And if the user didn't ask for it, it should damn well 
not be there.

> So how am I supposed to indicate to distro vendors that something should 
> be turned on? If you think that distro kernel maintainers really 
> understand every config option that goes past, I've got a bridge.

User configurations is _not_ your job. Your job is to make sure that the 
kernel works, and people who don't ask for new feaures don't get them.

		Linus
