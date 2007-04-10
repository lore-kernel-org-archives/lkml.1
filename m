Return-Path: <linux-kernel-owner+w=401wt.eu-S1030181AbXDJDck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030181AbXDJDck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 23:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932933AbXDJDck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 23:32:40 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:20228 "EHLO
	asav16.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932900AbXDJDcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 23:32:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KAJShGkZKhRO4UGdsb2JhbACHNohDAQEq
From: Dmitry Torokhov <dtor@insightbb.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc6
Date: Mon, 9 Apr 2007 23:32:36 -0400
User-Agent: KMail/1.9.3
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070408160954.edd248d1.akpm@linux-foundation.org>
In-Reply-To: <20070408160954.edd248d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704092332.37065.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 April 2007 19:09, Andrew Morton wrote:
> driver core:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/broken-out/update-documentation-driver-model-platformtxt.patch
> 

We should not encourage using platform_device_register_simple as we want
to obsolete this function.

-- 
Dmitry
