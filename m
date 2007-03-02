Return-Path: <linux-kernel-owner+w=401wt.eu-S1422906AbXCBHDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422906AbXCBHDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 02:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422907AbXCBHDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 02:03:42 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46091 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422906AbXCBHDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 02:03:42 -0500
Date: Thu, 1 Mar 2007 23:03:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@engr.sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Mel Gorman <mel@skynet.ie>, mingo@elte.hu,
       jschopp@austin.ibm.com, arjan@infradead.org,
       torvalds@linux-foundation.org, mbligh@mbligh.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related
 patches
Message-Id: <20070301230311.943d362b.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703012236160.1979@schroedinger.engr.sgi.com>
References: <20070302035751.GA15867@wotan.suse.de>
	<Pine.LNX.4.64.0703012001260.5548@schroedinger.engr.sgi.com>
	<20070302042149.GB15867@wotan.suse.de>
	<Pine.LNX.4.64.0703012022320.14299@schroedinger.engr.sgi.com>
	<20070302050625.GD15867@wotan.suse.de>
	<Pine.LNX.4.64.0703012137580.1768@schroedinger.engr.sgi.com>
	<20070302054944.GE15867@wotan.suse.de>
	<Pine.LNX.4.64.0703012150290.1768@schroedinger.engr.sgi.com>
	<20070302060831.GF15867@wotan.suse.de>
	<Pine.LNX.4.64.0703012213130.1917@schroedinger.engr.sgi.com>
	<20070302062950.GG15867@wotan.suse.de>
	<Pine.LNX.4.64.0703012236160.1979@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007 22:51:00 -0800 (PST) Christoph Lameter <clameter@engr.sgi.com> wrote:

> I'd love to have I/O support for huge pages.

direct-IO works.
