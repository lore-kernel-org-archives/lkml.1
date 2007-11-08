Return-Path: <linux-kernel-owner+w=401wt.eu-S1759722AbXKHCZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722AbXKHCZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbXKHCZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:25:20 -0500
Received: from ozlabs.org ([203.10.76.45]:52138 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbXKHCZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:25:19 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH][VIRTIO] Fix vring_init() ring computations
Date: Thu, 8 Nov 2007 13:25:17 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rusycorp.com.au>, virtualization@lists.osdl.org
References: <11944039492411-git-send-email-aliguori@us.ibm.com> <200711071657.40992.rusty@rustcorp.com.au> <473260FF.1030101@us.ibm.com>
In-Reply-To: <473260FF.1030101@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711081325.17558.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2007 12:06:07 Anthony Liguori wrote:
> Rusty Russell wrote:
> > On Wednesday 07 November 2007 13:52:29 Anthony Liguori wrote:
> >> This patch fixes a typo in vring_init().
> >
> > Thanks, applied.
> >
> > I've put it in the new, experimental virtio git tree on git.kernel.org.
>
> Hrm, perhaps you forgot to push?  I don't see it in the tree although I
> see the config ops refactoring.

It should be in the patches/1 branch.  I've pushed again...

Thanks,
Rusty.
