Return-Path: <linux-kernel-owner+w=401wt.eu-S1767367AbXDEW1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767367AbXDEW1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 18:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767370AbXDEW1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 18:27:05 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45811 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767367AbXDEW1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 18:27:03 -0400
Date: Thu, 5 Apr 2007 15:27:00 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: Andy Whitcroft <apw@shadowen.org>, akpm@linux-foundation.org,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       mbligh@google.com, linux-mm@kvack.org, ak@suse.de, hansendc@us.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 1/4] Generic Virtual Memmap suport for SPARSEMEM V3
In-Reply-To: <20070405.142900.59466568.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0704051525350.15901@schroedinger.engr.sgi.com>
References: <20070404230619.20292.4475.sendpatchset@schroedinger.engr.sgi.com>
 <20070405.142900.59466568.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Apr 2007, David Miller wrote:

> Hey Christoph, here is sparc64 support for this stuff.

Great!

> After implementing this and seeing more and more how it works, I
> really like it :-)
> 
> Thanks a lot for doing this work Christoph!

Thanks for the appreciation. CCing Andy Whitcroft who will hopefully 
merge this all of this together into sparsemem including the S/390 
implementation.


