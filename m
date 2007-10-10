Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbXJJQAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbXJJQAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 12:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755949AbXJJQAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 12:00:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38396 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbXJJQAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 12:00:09 -0400
Date: Wed, 10 Oct 2007 08:59:18 -0700
From: Greg KH <greg@kroah.com>
To: wit <is01kzh@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: about probing a device
Message-ID: <20071010155918.GA5824@kroah.com>
References: <105610bf0710091839r3b2fc1bfp4260ceaf6ad94b7@mail.gmail.com> <20071010044619.GA23561@kroah.com> <105610bf0710100841t1c9463c1q9742534c8bb0dfe5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <105610bf0710100841t1c9463c1q9742534c8bb0dfe5@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2007 at 11:41:47PM +0800, wit wrote:
> Thanks very much
> 
> > Why, is there some use for multiple drivers to devices that you want to
> > use?
> >
> 
> I'm just trying to figure out the difference between 2.4 & 2.6 device
> drivers. And this is just an issue that came up to my mind suddently.

For 2.4, we could not bind multiple drivers to devices either, so this
should not have changed.

thanks,

greg k-h
