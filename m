Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbZCTDVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbZCTDVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 23:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757914AbZCTDUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 23:20:46 -0400
Received: from kroah.org ([198.145.64.141]:43879 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757595AbZCTDUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 23:20:45 -0400
Date: Thu, 19 Mar 2009 20:06:08 -0700
From: Greg KH <greg@kroah.com>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC Aufs2 #3 2/2] split 'xino' entry under sysfs
Message-ID: <20090320030608.GA2638@kroah.com>
References: <1237439565-25039-1-git-send-email-hooanon05@yahoo.co.jp> <1237439565-25039-3-git-send-email-hooanon05@yahoo.co.jp> <20090320004539.GF18781@kroah.com> <3934.1237515949@jrobl> <20090320024249.GA19989@kroah.com> <4443.1237517709@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4443.1237517709@jrobl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 11:55:09AM +0900, hooanon05@yahoo.co.jp wrote:
> 
> Greg KH:
> > Really?  Try leaving them out for now and see if anyone notices :)
> 
> Ok, then I will move them to debugfs.
> Does the rule "one value per file" applied to debugfs too?

The only rule that debugfs has is:
	debugfs has no rules!

You can do whatever you want in there, have fun.

thanks,

greg k-h
