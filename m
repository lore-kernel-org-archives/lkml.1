Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbYKNSkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbYKNSkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 13:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbYKNSkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 13:40:32 -0500
Received: from mx1.suse.de ([195.135.220.2]:40421 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbYKNSkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 13:40:31 -0500
Date: Fri, 14 Nov 2008 10:35:22 -0800
From: Greg KH <gregkh@suse.de>
To: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] question
Message-ID: <20081114183522.GA23642@suse.de>
References: <491d6de8.0c636e0a.786d.ffffdd0e@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491d6de8.0c636e0a.786d.ffffdd0e@mx.google.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 08:23:59PM +0800, Qinghuang Feng wrote:
> sorry that the patch-send-tool coded by me had a bug, so the former 
> patches can't be sent to maillist. Now, the bug has fixed I think,
> so I resend them again :)
> 
> And I have a question, should all the init(exit) functions in a module
> be marked as __init(__exit)?

Probably, yes, they should.

> please ignore the following, it used to bypass my tool's 
> checking temporarily.

I think you need to fix your tool :)

You do know that git-send-email will probably do all that you need here,
right?

thanks,

greg k-h
