Return-Path: <linux-kernel-owner+w=401wt.eu-S1752246AbXDICg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbXDICg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 22:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbXDICgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 22:36:55 -0400
Received: from holomorphy.com ([66.93.40.71]:46205 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbXDICgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 22:36:55 -0400
Date: Sun, 8 Apr 2007 19:36:59 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Christoph Lameter <clameter@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 07/20] Allow paravirt backend to choose kernel PMD sharing
Message-ID: <20070409023659.GS2986@holomorphy.com>
References: <20070404191151.009821039@goop.org> <20070404191205.392155702@goop.org> <20070406164139.08cd343b.akpm@linux-foundation.org> <4616DFB2.4020802@goop.org> <20070406172844.12f7b8e7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406172844.12f7b8e7.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Apr 2007 17:02:58 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> You're too kind.  wli's comment on the first version of this patch was
>> something along the lines of "this patch causes a surprising amount of
>> damage for what little it achieves".

On Fri, Apr 06, 2007 at 05:28:44PM -0700, Andrew Morton wrote:
> Damn, I wish I'd said that.

ISTR it went:

On Fri, Feb 16, 2007 at 02:21:07PM -0800, William Lee Irwin III wrote:
> The amount of violence this patch manages to commit is phenomenal for
> what little it actually does. There are also a number of oddities

Cheers.


-- wli
