Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbYJBXJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbYJBXJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbYJBXJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:09:04 -0400
Received: from kroah.org ([198.145.64.141]:41039 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752980AbYJBXJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:09:03 -0400
Date: Thu, 2 Oct 2008 16:06:03 -0700
From: Greg KH <greg@kroah.com>
To: xiong.huang@atheros.com, csnook@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: atl2 network driver status
Message-ID: <20081002230603.GA11609@kroah.com>
References: <20081002230246.GA11570@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002230246.GA11570@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 04:02:46PM -0700, Greg KH wrote:
> Hi,
> 
> In looking for drivers to add to drivers/staging/ I ran across the atl2
> driver that is currently in the Fedora and Ubuntu kernel trees.
> 
> This driver doesn't look to be scheduled for inclusion in the upstream
> netdev git tree for submission for 2.6.28, is there any reason why it is
> still out-of-the-tree?
> 
> And, if it's not going into 2.6.28, any objection for me adding it to
> the drivers/staging/ tree?  If so, I need a list of reasons why it is
> not merged upstream properly so far so that people know what to work on
> in order to get it there.

Ok, in looking at the code, I see a list of things that probably need to
be fixed up properly, but it would be nice to see what others think the
reasons are :)

thanks,

greg k-h
