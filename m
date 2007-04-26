Return-Path: <linux-kernel-owner+w=401wt.eu-S1031230AbXDZOtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031230AbXDZOtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031233AbXDZOtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:49:09 -0400
Received: from holomorphy.com ([66.93.40.71]:45151 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031230AbXDZOtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:49:08 -0400
Date: Thu, 26 Apr 2007 07:49:31 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426144931.GG19966@holomorphy.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com> <46304C74.9040304@yahoo.com.au> <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com> <46305177.7060102@yahoo.com.au> <Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Nick Piggin wrote:
>> Block size > page cache size.

On Thu, Apr 26, 2007 at 12:22:42AM -0700, Christoph Lameter wrote:
> But what do you mean with it? A block is no longer a contiguous section of 
> memory. So you have redefined the term.

AIUI a block is a contiguous section of disk, not memory, with further
qualifications.


On Thu, 26 Apr 2007, Nick Piggin wrote:
>> You guys have a couple of problems, firstly you need to have ia64
>> filesystems accessable to x86_64. And secondly you have these controllers
>> without enough sg entries for nice sized IOs.

On Thu, Apr 26, 2007 at 12:22:42AM -0700, Christoph Lameter wrote:
> This is not sgi specific sorry.

Throw Oracle in the mix. I expect other IHV's and ISV's are also
interested, but probably need to be asked in some way to which they're
more easily able to respond, as their minions are not necessarily
reading this thread. It's a relatively broad point of interest.


-- wli
