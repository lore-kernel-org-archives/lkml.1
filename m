Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbYFNEDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbYFNEDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 00:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbYFNEDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 00:03:08 -0400
Received: from ozlabs.org ([203.10.76.45]:43293 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbYFNECr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 00:02:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 1/2] virtio: Use bus_type probe and remove methods
Date: Sat, 14 Jun 2008 14:02:26 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <1213361201-10854-1-git-send-email-markmc@redhat.com>
In-Reply-To: <1213361201-10854-1-git-send-email-markmc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806141402.27175.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 June 2008 22:46:40 Mark McLoughlin wrote:
> Hook up to the probe() and remove() methods in bus_type
> rather than device_driver. The latter has been preferred
> since 2.6.16.
>
> Signed-off-by: Mark McLoughlin <markmc@redhat.com>

Thanks, applied.

Cheers,
Rusty.
