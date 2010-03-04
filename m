Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab0CDVGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:06:44 -0500
Received: from kroah.org ([198.145.64.141]:49379 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756474Ab0CDVGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:06:43 -0500
Date: Thu, 4 Mar 2010 13:06:39 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Weirdness in patch
Message-ID: <20100304210639.GA1392@kroah.com>
References: <Pine.LNX.4.44L0.1003041511070.1305-100000@iolanthe.rowland.org>
 <20100304210119.GA27873@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100304210119.GA27873@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 01:01:19PM -0800, Greg KH wrote:
> Yes, the original patch is correct, but somehow the -all patches are not
> getting generated correctly.  I'll go look into what broke in my
> scripts.  Sorry about that, and thanks for letting me know.

Ok, it all seems to be working now, please let me know if anything looks
wrong after master.kernel.org syncs everything out in about 30 minutes
or so.

thanks,

greg k-h
