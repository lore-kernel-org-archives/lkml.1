Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbZDTW5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbZDTW5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756425AbZDTW5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:57:02 -0400
Received: from kroah.org ([198.145.64.141]:60040 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756242AbZDTW5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:57:00 -0400
Date: Mon, 20 Apr 2009 15:53:58 -0700
From: Greg KH <greg@kroah.com>
To: David VomLehn <dvomlehn@cisco.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [Patch] Wait for console to become available, ver 3
Message-ID: <20090420225358.GC28697@kroah.com>
References: <20090420143010.697c7380.akpm@linux-foundation.org> <Pine.LNX.4.44L0.0904201744410.6832-100000@iolanthe.rowland.org> <20090420151400.11afd62a.akpm@linux-foundation.org> <20090420223500.GB11068@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420223500.GB11068@cuplxvomd02.corp.sa.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 03:35:00PM -0700, David VomLehn wrote:
> With USB, you just can't *ever* get it right. There is no limit on how
> long a device has to tell you its there. I wish this weren't the case,
> but our good friends in the USB world tell us that we have been lucky
> to have had USB consoles work as long as they have.

Lucky?  You all are _more_ than lucky.  USB consoles was a bad hack
written on a drunken dare.  I'm still constantly amazed that the thing
even works at all, let alone the fact that people are actually using it :)

The things I agree to over beers, you would think I would learn...

thanks,

greg k-h
