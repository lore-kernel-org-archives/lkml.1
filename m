Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbXKNXT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbXKNXT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 18:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbXKNXTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 18:19:20 -0500
Received: from ozlabs.org ([203.10.76.45]:59275 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153AbXKNXTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 18:19:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18235.32982.439970.359975@cargo.ozlabs.ibm.com>
Date: Thu, 15 Nov 2007 10:12:22 +1100
From: Paul Mackerras <paulus@samba.org>
To: David Miller <davem@davemloft.net>
Cc: hch@infradead.org, akpm@linux-foundation.org, gregkh@suse.de,
       mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
In-Reply-To: <20071114.150303.13732085.davem@davemloft.net>
References: <18234.58380.400222.329961@cargo.ozlabs.ibm.com>
	<20071114.040758.101673950.davem@davemloft.net>
	<18235.28062.309910.416774@cargo.ozlabs.ibm.com>
	<20071114.150303.13732085.davem@davemloft.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller writes:

> From: Paul Mackerras <paulus@samba.org>
> Date: Thu, 15 Nov 2007 08:50:22 +1100
> 
> > I'd prefer to have a transaction() system call like I suggested to
> > Nick rather than overloading read() like this.
> 
> So much for getting rid of the extra system calls...

*I* never had a problem with a few extra system calls.  I don't
 understand why you (apparently) do.

Paul.
