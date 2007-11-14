Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbXKNXDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbXKNXDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 18:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756077AbXKNXDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 18:03:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43092
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755747AbXKNXDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 18:03:04 -0500
Date: Wed, 14 Nov 2007 15:03:03 -0800 (PST)
Message-Id: <20071114.150303.13732085.davem@davemloft.net>
To: paulus@samba.org
Cc: hch@infradead.org, akpm@linux-foundation.org, gregkh@suse.de,
       mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
From: David Miller <davem@davemloft.net>
In-Reply-To: <18235.28062.309910.416774@cargo.ozlabs.ibm.com>
References: <18234.58380.400222.329961@cargo.ozlabs.ibm.com>
	<20071114.040758.101673950.davem@davemloft.net>
	<18235.28062.309910.416774@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Thu, 15 Nov 2007 08:50:22 +1100

> I'd prefer to have a transaction() system call like I suggested to
> Nick rather than overloading read() like this.

So much for getting rid of the extra system calls...
