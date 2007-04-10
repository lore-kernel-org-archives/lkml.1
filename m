Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbXDJKn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbXDJKn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 06:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbXDJKn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 06:43:56 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1801 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbXDJKnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 06:43:55 -0400
Message-ID: <461B6A5F.3020007@shadowen.org>
Date: Tue, 10 Apr 2007 11:43:43 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       mbligh@google.com, linux-mm@kvack.org, ak@suse.de, hansendc@us.ibm.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 1/4] Generic Virtual Memmap suport for SPARSEMEM V3
References: <20070404230619.20292.4475.sendpatchset@schroedinger.engr.sgi.com> <20070405.142900.59466568.davem@davemloft.net> <Pine.LNX.4.64.0704051525350.15901@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704051525350.15901@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 5 Apr 2007, David Miller wrote:
> 
>> Hey Christoph, here is sparc64 support for this stuff.
> 
> Great!
> 
>> After implementing this and seeing more and more how it works, I
>> really like it :-)
>>
>> Thanks a lot for doing this work Christoph!
> 
> Thanks for the appreciation. CCing Andy Whitcroft who will hopefully 
> merge this all of this together into sparsemem including the S/390 
> implementation.

Yep grabbed this one and added it to the stack.  Now to find a sparc to
test it with!

-apw
