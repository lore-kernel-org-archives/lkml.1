Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbXD0UC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbXD0UC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757173AbXD0UC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:02:27 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757172AbXD0UC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:02:27 -0400
Date: Fri, 27 Apr 2007 13:01:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [GIT PATCH] USB patches for 2.6.21
In-Reply-To: <20070427185646.GA17578@kroah.com>
Message-ID: <alpine.LFD.0.98.0704271300050.9964@woody.linux-foundation.org>
References: <20070427185422.GA17509@kroah.com>
 <20070427185646.GA17578@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Apr 2007, Greg KH wrote:
> 
> Ugh, I just realized that this mite break people using 'git bisect' and
> diving down into this usb branch.  If you want, I can just redo this
> whole tree after you pull the driver patches so this doesn't happen.

Let's do that. I pushed out my pull of the device core, and you can rebase 
(or whatever) on top of that to make it buildable along the whole series.

		Linus
