Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbZEEEZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbZEEEZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 00:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZEEEYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 00:24:31 -0400
Received: from ozlabs.org ([203.10.76.45]:53977 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbZEEEY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 00:24:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] virtio: add missing include to virtio_net.h
Date: Tue, 5 May 2009 13:54:22 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20090428154654.19053.92829.stgit@localhost.localdomain>
In-Reply-To: <20090428154654.19053.92829.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905051354.22713.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 01:16:54 am Grant Likely wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
>
> virtio_net.h uses the macro ETH_ALEN which is defined in linux/if_ether.h.
> Discovered when hacking on virtio-over-pci patches.

Thanks, I've applied this.

Rusty.
