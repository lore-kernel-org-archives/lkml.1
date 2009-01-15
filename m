Return-Path: <linux-kernel-owner+w=401wt.eu-S934433AbZAOVCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934433AbZAOVCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765744AbZAOUaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:30:21 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:38610 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933036AbZAOUaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:30:19 -0500
Date: Thu, 15 Jan 2009 14:29:11 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, andi@firstfloor.org, ak@linux.intel.com,
       rth@twiddle.net, sfr@canb.auug.org.au, travis@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] compiler-gcc.h: add more comments to RELOC_HIDE
In-Reply-To: <200901151227.27935.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0901151428020.28153@quilx.com>
References: <200901100040.n0A0eruc013680@imap1.linux-foundation.org>
 <20090110122945.GA28033@elte.hu> <Pine.LNX.4.64.0901121128470.30369@quilx.com>
 <200901151227.27935.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009, Rusty Russell wrote:

> > The cast should cause the C compiler to drop all assumptions about size.
>
> No, and that's the point.  Sorry, at this point you need to talk to a gcc expert.  As I have said, I did and I believe what he told me.

The gcc expert that created this measss is cced on this thread and so
far he not spoken up. Richard?


