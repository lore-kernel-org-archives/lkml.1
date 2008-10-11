Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbYJKPlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbYJKPlp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 11:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbYJKPlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 11:41:24 -0400
Received: from kroah.org ([198.145.64.141]:55980 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754475AbYJKPlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 11:41:23 -0400
Date: Sat, 11 Oct 2008 08:39:55 -0700
From: Greg KH <greg@kroah.com>
To: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
Cc: linux-kernel@vger.kernel.org, David Rowe <david@rowetel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 16/23] Staging: add echo cancelation module
Message-ID: <20081011153955.GB31405@kroah.com>
References: <20081010224130.GA30117@kroah.com> <1223678567-30143-16-git-send-email-greg@kroah.com> <20081011063310.GW31838@xorcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081011063310.GW31838@xorcom.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2008 at 08:33:10AM +0200, Tzafrir Cohen wrote:
> While there are a number of small issues in this code, I personally
> would like to first and foremost get a usable interface so I could get a
> working echo canceller module into dahdi:
> http://svn.digium.com/svn/dahdi/linux/trunk/
> http://svn.digium.com/svn/dahdi/linux/trunk/drivers/dahdi/
> 
> (Don't preach me that it should be included in mainline. Or if you do,
> do it in a different thread, please)

Ok, different thread :)

What is needed in order for you to include this in mainline?

Can it be placed in drivers/staging for now?

thanks,

greg k-h
