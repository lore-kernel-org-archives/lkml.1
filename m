Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbYJXTen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbYJXTen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 15:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYJXTef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 15:34:35 -0400
Received: from kroah.org ([198.145.64.141]:44130 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751887AbYJXTee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 15:34:34 -0400
Date: Fri, 24 Oct 2008 11:08:30 -0700
From: Greg KH <greg@kroah.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc1
Message-ID: <20081024180830.GA26341@kroah.com>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org> <adar666sk78.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adar666sk78.fsf@cisco.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 09:14:51PM -0700, Roland Dreier wrote:
>  >  - Most screwed-up clock award goes to:
>  > 
>  > 	Greg Kroah-Hartman
>  > 
>  >    for his commit 51b90540, which claims to be from April 9 - six years 
>  >    ago! And it's a fix to a driver that was merged this July!
> 
> Maybe that commit really is from a time before printk supported the
> "%zd" format for size_t :)

Heh :(

Sorry about this, stupid "default date for my patch" script messed up.
I suck at bash scripting at times...

greg k-h
