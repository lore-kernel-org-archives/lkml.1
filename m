Return-Path: <linux-kernel-owner+w=401wt.eu-S1751689AbZGXA0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbZGXA0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 20:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZGXA0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 20:26:18 -0400
Received: from kroah.org ([198.145.64.141]:44612 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbZGXA0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 20:26:11 -0400
Date: Thu, 23 Jul 2009 17:24:39 -0700
From: Greg KH <greg@kroah.com>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
       charles.f.johnson@intel.com
Subject: Re: [PATCH] Revsion 2 of the security processor kernel driver;
Message-ID: <20090724002439.GC26267@kroah.com>
References: <1248388211-13881-1-git-send-email-mark.a.allyn@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248388211-13881-1-git-send-email-mark.a.allyn@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 03:30:11PM -0700, Mark Allyn wrote:
>  For the upstream community, this is revision 2. Changes are the
>  relocation of this driver to the staging area.
> 
>  This is the Linux kernel driver for the Security Processor, which is
>  a hardware device the provides cryptographic, secure storage, and
>  key management services. 
> 
>  Please be aware that this patch does not contain any encryption
>  algorithm. It only transports data to and from user space 
>  applications to the security processor.
> 
>  Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>

Can you provide me a TODO file that lists what is remaining to be done
to this driver in order to get it accepted into the main portion of the
kernel tree?

And do that with the patch itself, so it would require a respin of this
one?

thanks,

greg k-h
