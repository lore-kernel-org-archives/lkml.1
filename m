Return-Path: <linux-kernel-owner+w=401wt.eu-S1757038AbXD0TQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbXD0TQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbXD0TQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 15:16:37 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757086AbXD0TQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 15:16:35 -0400
Date: Fri, 27 Apr 2007 12:15:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Christoph Lameter <clameter@sgi.com>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-Id: <20070427121557.de9e8b4a.akpm@linux-foundation.org>
In-Reply-To: <20070427134451.GP19966@holomorphy.com>
References: <20070424222105.883597089@sgi.com>
	<20070426190438.3a856220.akpm@linux-foundation.org>
	<20070427022731.GF65285596@melbourne.sgi.com>
	<20070426195357.597ffd7e.akpm@linux-foundation.org>
	<20070427042046.GI65285596@melbourne.sgi.com>
	<20070426221528.655d79cb.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
	<20070426235542.bad7035a.akpm@linux-foundation.org>
	<20070427134451.GP19966@holomorphy.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 06:44:51 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:

> On Thu, Apr 26, 2007 at 11:55:42PM -0700, Andrew Morton wrote:
> > Please address my point: if in five years time x86 has larger or varible
> > pagesize, this code will be a permanent millstone around our necks which we
> > *should not have merged*.
> > And if in five years time x86 does not have larger pagesize support then
> > the manufacturers would have decided that 4k pages are not a performance
> > problem, so we again should not have merged this code.
> 
> So the verdict is wait 5 years, see if x86 did anything, and so on.

You missed the bit about "evaluate alternatives".
