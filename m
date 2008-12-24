Return-Path: <linux-kernel-owner+w=401wt.eu-S1751815AbYLXUBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbYLXUBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 15:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbYLXUBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 15:01:38 -0500
Received: from kroah.org ([198.145.64.141]:51092 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750852AbYLXUBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 15:01:37 -0500
Date: Wed, 24 Dec 2008 11:59:36 -0800
From: Greg KH <greg@kroah.com>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       linux-usb@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/3] USB: FHCI: Driver should be responsible for
	managing endpoint queues
Message-ID: <20081224195935.GA11531@kroah.com>
References: <20081223210322.GA2802@oksana.dev.rtsoft.ru> <20081224191303.GA21815@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224191303.GA21815@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2008 at 10:13:03PM +0300, Anton Vorontsov wrote:
> Follow these changes for the FHCI driver:

Hm, would it just make more sense to respin the whole driver?  That way
it's never in the tree in a "broken" state?

thanks,

greg k-h
