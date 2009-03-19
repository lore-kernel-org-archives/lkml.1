Return-Path: <linux-kernel-owner+w=401wt.eu-S1760826AbZCSUOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760826AbZCSUOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755838AbZCSUOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:14:20 -0400
Received: from kroah.org ([198.145.64.141]:35697 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755267AbZCSUOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:14:19 -0400
Date: Thu, 19 Mar 2009 13:11:36 -0700
From: Greg KH <greg@kroah.com>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>
Cc: Dave Airlie <airlied@gmail.com>, David Airlie <airlied@linux.ie>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core
	changes
Message-ID: <20090319201136.GB17094@kroah.com>
References: <20090319040809.GA29249@kroah.com> <21d7e9970903182348v57a78188ocefe138d353ee197@mail.gmail.com> <49C21B0B.4060809@shipmail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49C21B0B.4060809@shipmail.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 11:14:35AM +0100, Thomas Hellström wrote:
>> First off, the non-staging patches need more complete changelog entries,
>> a bit of meaning goes a long way. I'll ack them if they are documented and
>> make sense. The unlocked ioctl hook makes sense to me at least!
>>   
>
> For the non-staging patches, (which also sit in the modesetting-newttm 
> tree), I can add some more elaborate comments. However I think all of
> them are targeted to support functionality for TTM, so unless the TTM
> code goes into staging or mainstream, there is little point in merging
> them to core drm before other drivers find them useful.
>
> Although I see the patch adding TTM is including some backwards
> compatibility defines (In particular the PAT compat stuff) that needs
> to be stripped.

Great, care to respin it and send it to me?

thanks,

greg k-h
