Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbYJPCWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbYJPCWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 22:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbYJPCWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 22:22:05 -0400
Received: from kroah.org ([198.145.64.141]:44040 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753500AbYJPCWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 22:22:04 -0400
Date: Wed, 15 Oct 2008 19:18:40 -0700
From: Greg KH <greg@kroah.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081016021840.GA27389@kroah.com>
References: <20081016002509.GA25868@kroah.com> <48F692E9.2080008@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F692E9.2080008@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 06:03:37PM -0700, H. Peter Anvin wrote:
> Greg KH wrote:
>> Yes, we can handle the major/minor macros in the kernel to provide a
>> compatible number so that automated scripts will not break, that's not a
>> big deal.
>> Any thoughts?
>> Let the bike-shedding begin!
>
> Personally I find that having a simple counter is kind of nice, simply 
> because one can talk about 27, 28, 29, ... and actually be able to rely on 
> it being stable.

I would love to do that, start with 28.0 and go from there.

It's just a number, might as well just treat it as such :)

thanks,

greg k-h
