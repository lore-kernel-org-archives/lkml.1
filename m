Return-Path: <linux-kernel-owner+w=401wt.eu-S1761969AbXGTD1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761969AbXGTD1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 23:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbXGTD1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 23:27:34 -0400
Received: from ozlabs.org ([203.10.76.45]:55970 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338AbXGTD1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 23:27:33 -0400
Subject: Re: lguest, Re: -mm merge plans for 2.6.23
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20070719172746.GA17710@lst.de>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <20070711122324.GA21714@lst.de>
	 <1184203311.6005.664.camel@localhost.localdomain>
	 <20070711.192829.08323972.davem@davemloft.net>
	 <1184208521.6005.695.camel@localhost.localdomain>
	 <20070711212435.abd33524.akpm@linux-foundation.org>
	 <1184215943.6005.745.camel@localhost.localdomain>
	 <20070719172746.GA17710@lst.de>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 13:27:26 +1000
Message-Id: <1184902046.10380.257.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-19 at 19:27 +0200, Christoph Hellwig wrote:
> The version that just got into mainline still has the __put_task_struct
> export despite not needing it anymore.  Care to fix this up?

No, it got patched in then immediately patched out again.  Andrew
mis-mixed my patches, but there have been so many of them I find it hard
to blame him.

Rusty.

