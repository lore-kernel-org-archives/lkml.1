Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbZHYIps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbZHYIps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753967AbZHYIpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:45:47 -0400
Received: from ozlabs.org ([203.10.76.45]:49499 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbZHYIpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:45:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCHv4 0/2] vhost: a kernel-level virtio server
Date: Tue, 25 Aug 2009 18:15:41 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com
References: <20090819150029.GA4236@redhat.com>
In-Reply-To: <20090819150029.GA4236@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908251815.42707.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009 12:30:29 am Michael S. Tsirkin wrote:
> Rusty, could you review and comment on the patches please?  Since most
> of the code deals with virtio from host side, I think it will make sense
> to merge them through your tree. What do you think?

Yep, I've been waiting for all the other comments, then I got ill.

Now I'm all recovered, what better way to spend an evening than reviewing
fresh code?

New dir seems fine to me, too.

Thanks,
Rusty.
