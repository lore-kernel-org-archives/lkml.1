Return-Path: <linux-kernel-owner+w=401wt.eu-S1030923AbXD1CUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030923AbXD1CUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 22:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030940AbXD1CUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 22:20:35 -0400
Received: from holomorphy.com ([66.93.40.71]:48062 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030923AbXD1CUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 22:20:34 -0400
Date: Fri, 27 Apr 2007 19:21:01 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070428022101.GS19966@holomorphy.com>
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org> <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org> <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org> <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com> <20070426235542.bad7035a.akpm@linux-foundation.org> <20070427134451.GP19966@holomorphy.com> <20070427121557.de9e8b4a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427121557.de9e8b4a.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 11:55:42PM -0700, Andrew Morton wrote:
>>> Please address my point: if in five years time x86 has larger or varible
>>> pagesize, this code will be a permanent millstone around our necks which we
>>> *should not have merged*.
>>> And if in five years time x86 does not have larger pagesize support then
>>> the manufacturers would have decided that 4k pages are not a performance
>>> problem, so we again should not have merged this code.

On Fri, 27 Apr 2007 06:44:51 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:
>> So the verdict is wait 5 years, see if x86 did anything, and so on.

On Fri, Apr 27, 2007 at 12:15:57PM -0700, Andrew Morton wrote:
> You missed the bit about "evaluate alternatives".

No worries. I'm used to being on the wrong side of things. I'll have
no trouble picking out the alternative least likely to be accepted. ;)


-- wli
