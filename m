Return-Path: <linux-kernel-owner+w=401wt.eu-S1759652AbZE0Jal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbZE0Jal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 05:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZE0Jae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 05:30:34 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43914 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbZE0Jae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 05:30:34 -0400
Date: Wed, 27 May 2009 11:16:13 +0200
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, holtmann@linux.intel.com,
       yi.zhu@intel.com, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] firmware: Allocate firmware id dynamically
Message-ID: <20090527091611.GA3986@tuxdriver.com>
References: <20090526140423.GA14683@sortiz.org> <ac3eb2510905260711hb273541i8d69128b88933f7f@mail.gmail.com> <20090526132351.9805f1e8.akpm@linux-foundation.org> <20090527115748.9ff0bad1.sfr@canb.auug.org.au> <20090527081732.GB3777@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527081732.GB3777@sortiz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 10:17:33AM +0200, Samuel Ortiz wrote:

> > next-20090526:drivers/net/wireless/p54/p54usb.c

> All of those have been taken care of by my last patch set, see:
> http://lkml.org/lkml/2009/5/26/518
> 
> The p54usb one has been sent to John and linux-wireless as it's coming from
> wireless-testing.

Is that patch dependent on other p54 bits in wireless-next-2.6?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
