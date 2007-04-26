Return-Path: <linux-kernel-owner+w=401wt.eu-S1751743AbXDZS7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbXDZS7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbXDZS7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:59:44 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56701 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751732AbXDZS7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:59:44 -0400
Date: Thu, 26 Apr 2007 11:59:43 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: David Chinner <dgc@sgi.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <m17irzkm8q.fsf@ebiederm.dsl.xmission.com>
Message-ID: <Pine.LNX.4.64.0704261155100.11420@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
 <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com>
 <m1k5vzmoo7.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704261103150.3263@schroedinger.engr.sgi.com>
 <m17irzkm8q.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Eric W. Biederman wrote:

> If you can make small things go fast, everything speeds up.
> If you can only make big things go fast only some things speed up.
> 
> I want to make small things go fast so everything speeds up.

A reductionist operating system theory? Have you ever heard of emergent 
properties? A system comprised of pieces can as a whole exibit other 
characteristics than the basic elements would provide.

I think it is wrong to use the same small things for big things. You 
would not tow a tanker with your bicycle. Similarly you could use small 
pages for text files but huge page sizes when you need to transfer 
gigabytes or terabytes of memory. Its wrong to dictate ones size fits 
all. (Memories of my relatives in the eastern bloc surface but I better shut up.)

