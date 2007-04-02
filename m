Return-Path: <linux-kernel-owner+w=401wt.eu-S965994AbXDBXCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965994AbXDBXCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 19:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966051AbXDBXCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 19:02:20 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37900 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965994AbXDBXCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 19:02:19 -0400
Date: Mon, 2 Apr 2007 16:02:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: akpm@osdl.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       mpm@selenic.com
Subject: Re: [SLUB 2/2] i386 arch page size slab fixes
In-Reply-To: <20070402230051.GI2986@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0704021601220.2481@schroedinger.engr.sgi.com>
References: <20070331193056.1800.68058.sendpatchset@schroedinger.engr.sgi.com>
 <20070331193107.1800.28259.sendpatchset@schroedinger.engr.sgi.com>
 <20070402230051.GI2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007, William Lee Irwin III wrote:

> This doesn't quite cover all bases. The changes to pageattr.c and
> fault.c are dubious and need verification at the very least. They were
> largely slapped together to get the files past the compiler for the
> performance comparisons that were never properly done.

I looked through them but then I am no i386 specialist though. Looked 
fine.


