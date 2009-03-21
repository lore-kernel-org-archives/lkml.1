Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbZCUDAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbZCUDAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 23:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZCUDAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 23:00:11 -0400
Received: from kroah.org ([198.145.64.141]:34401 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752553AbZCUDAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 23:00:10 -0400
Date: Fri, 20 Mar 2009 19:39:57 -0700
From: Greg KH <greg@kroah.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core
	changes
Message-ID: <20090321023957.GA6467@kroah.com>
References: <20090319040809.GA29249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319040809.GA29249@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 09:08:09PM -0700, Greg KH wrote:
> Hi,
> 
> Here's 5 patches that add the Intel Poulsbo/Morrestown DRM driver to the
> kernel tree.

Ok, in reviewing the issues that Alan rightfully brought up, I'm going
to "retract" these patches right now and go back and try to only get the
2d stuff up and working properly.

Due to a vacation on my side in the next few weeks, this might take a
while, I'll come back when I have something that is working and doesn't
support the binary blob mess.

thanks,

greg k-h
