Return-Path: <linux-kernel-owner+w=401wt.eu-S1763277AbZE0PJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763277AbZE0PJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 11:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763919AbZE0PI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 11:08:59 -0400
Received: from kroah.org ([198.145.64.141]:53507 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762302AbZE0PI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 11:08:57 -0400
Date: Wed, 27 May 2009 08:04:35 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, holtmann@linux.intel.com,
       yi.zhu@intel.com, linux-kernel@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] firmware: Allocate firmware id dynamically
Message-ID: <20090527150435.GA31097@kroah.com>
References: <20090526140423.GA14683@sortiz.org> <ac3eb2510905260711hb273541i8d69128b88933f7f@mail.gmail.com> <20090526132351.9805f1e8.akpm@linux-foundation.org> <20090527115748.9ff0bad1.sfr@canb.auug.org.au> <20090527081732.GB3777@sortiz.org> <ac3eb2510905270130m752eb6bo767f7f3817cb1742@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510905270130m752eb6bo767f7f3817cb1742@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 10:30:19AM +0200, Kay Sievers wrote:
> On Wed, May 27, 2009 at 10:17, Samuel Ortiz <sameo@linux.intel.com> wrote:
> 
> >> next-20090526:samples/firmware_class/firmware_sample_firmware_class.c
> > Do I really need to fix this one too ?
> 
> I does not compile since ages, it is totally outdated and uses the
> long removed struct class_device. And we really don't need an example
> for firmware loading, I think. This file should just be deleted.

Yeah, I had plans to write it "properly", but it's at the end of my long
TODO list :(

I'll just go delete the thing instead.

thanks,

greg k-h
