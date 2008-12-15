Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbYLOW17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbYLOW17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 17:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYLOW1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 17:27:51 -0500
Received: from ozlabs.org ([203.10.76.45]:37246 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbYLOW1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 17:27:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 2/4] virtio: do not statically allocate root device
Date: Tue, 16 Dec 2008 08:57:47 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org,
       Anthony Liguori <aliguori@us.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
References: <20081212190730.GB2950@kroah.com> <1229345909-27229-1-git-send-email-markmc@redhat.com> <1229345909-27229-2-git-send-email-markmc@redhat.com>
In-Reply-To: <1229345909-27229-2-git-send-email-markmc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812160857.48321.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 December 2008 23:28:27 Mark McLoughlin wrote:
> We shouldn't be statically allocating the root device object,
> so dynamically allocate it using root_device_register()
> instead.

This and 3/4 which would normally go through me:

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks Greg,
Rusty.
