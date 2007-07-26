Return-Path: <linux-kernel-owner+w=401wt.eu-S933782AbXGZRJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782AbXGZRJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 13:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762830AbXGZRJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 13:09:41 -0400
Received: from hu-out-0506.google.com ([72.14.214.230]:27863 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762787AbXGZRJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 13:09:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=adG9E+qLUYVRMC2cIwH4oNuUuU6YSx0hwdIoDStjbLzh/TY6wb487i6XJTGETunjgQd5tr+6PvoGQkXfU1YDOaCMQWT1il+XTxpX+lzQa0cJ2O3CgQOuH8fV8iU2/CDlqhe4d4rO5Owpx4CXw8kv093odY6HueIJLnaoaDZilNM=
Date: Thu, 26 Jul 2007 18:09:23 +0100
From: Xudong Guan <xudong.guan@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1: no setup signature found...
Message-ID: <20070726170923.GA15125@xguan-laptop>
References: <20070724112618.GA4431@gollum.tnic> <20070726150854.GA7034@xguan-laptop> <46A8BB6C.6050903@zytor.com> <20070726163053.GA4570@gollum.tnic> <20070726163618.GA13789@xguan-laptop> <20070726165906.GB4570@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726165906.GB4570@gollum.tnic>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:59(+0200) Thu 26 Jul, Borislav Petkov wrote:
> On Thu, Jul 26, 2007 at 05:36:18PM +0100, Xudong Guan wrote:
> > On my real machine with grub 0.97, there is no problem loading the
> > same kernel.
> 
> Do you mean the kernel with the 4fd06960f120e02e9abc802a09f9511c400042a5 commit
> on top?

No, I mean v2.6.23-rc1-171-ge4903fb (HEAD of torvalds-linux-2.6.git as of
this writing), which can not be loaded by grub 0.91, but can be loaded
by grub 0.97 (at least on my machine). Sorry for the confusion.

Xudong
