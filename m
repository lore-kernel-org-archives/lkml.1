Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbXD0AUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbXD0AUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbXD0AUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:20:54 -0400
Received: from holomorphy.com ([66.93.40.71]:33077 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215AbXD0AUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:20:53 -0400
Date: Thu, 26 Apr 2007 17:21:10 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Mel Gorman <mel@skynet.ie>
Cc: Jens Axboe <jens.axboe@oracle.com>, Christoph Lameter <clameter@sgi.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070427002110.GL19966@holomorphy.com>
References: <m1mz0vkoux.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704261059500.3263@schroedinger.engr.sgi.com> <20070426180358.GG2017@kernel.dk> <20070426180932.GA10642@infradead.org> <20070426181249.GH2017@kernel.dk> <Pine.LNX.4.64.0704261127550.3560@schroedinger.engr.sgi.com> <20070426182945.GJ2017@kernel.dk> <Pine.LNX.4.64.0704261134080.3656@schroedinger.engr.sgi.com> <20070426183935.GK2017@kernel.dk> <20070426202202.GI16909@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426202202.GI16909@skynet.ie>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (26/04/07 20:39), Jens Axboe didst pronounce:
>> But don't push large pages as the only solution to larger ios, because
>> that is trivially not true.

On Thu, Apr 26, 2007 at 09:22:02PM +0100, Mel Gorman wrote:
> Would it be fair to say that your approach and using large pages are not
> mutually exclusive solutions? It seems a lot of the debate here is
> assuming there is One And Only One Solution for larger ios.

I'd like to see how all the strategies mentioned thus far do in
conjunction.


-- wli
