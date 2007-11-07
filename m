Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbXKGF5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbXKGF5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 00:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbXKGF5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 00:57:12 -0500
Received: from ozlabs.org ([203.10.76.45]:33530 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995AbXKGF5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 00:57:12 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH][VIRTIO] Fix vring_init() ring computations
Date: Wed, 7 Nov 2007 16:57:40 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Anthony Liguori <aliguori@us.ibm.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rusycorp.com.au>, virtualization@lists.osdl.org
References: <11944039492411-git-send-email-aliguori@us.ibm.com>
In-Reply-To: <11944039492411-git-send-email-aliguori@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711071657.40992.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2007 13:52:29 Anthony Liguori wrote:
> This patch fixes a typo in vring_init(). 

Thanks, applied.

I've put it in the new, experimental virtio git tree on git.kernel.org.

Cheers,
Rusty.
