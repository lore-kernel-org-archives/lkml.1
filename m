Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYHKDeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYHKDeJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 23:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYHKDdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 23:33:46 -0400
Received: from ozlabs.org ([203.10.76.45]:57460 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbYHKDdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 23:33:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: export virtio_rng.h
Date: Mon, 11 Aug 2008 12:46:05 +1000
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization@lists.linux-foundation.org
References: <200808081115.07411.borntraeger@de.ibm.com>
In-Reply-To: <200808081115.07411.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808111246.05488.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 August 2008 19:15:07 Christian Borntraeger wrote:
> Hello Rusty,
>
> The entropy device was added after we exported all virtio headers. This
> patch adds virtio_rng.h to the exportable userspace headers.
>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

Thanks, applied!

Rusty.
