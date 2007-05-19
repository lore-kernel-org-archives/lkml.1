Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbXESCDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbXESCDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 22:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbXESCDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 22:03:42 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52116 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753631AbXESCDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 22:03:41 -0400
Date: Fri, 18 May 2007 19:03:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: apw@shadowen.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-arch@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [rfc] increase struct page size?! (now sparsemem vmemmap)
In-Reply-To: <20070519012530.GB15569@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0705181901130.14521@schroedinger.engr.sgi.com>
References: <20070518040854.GA15654@wotan.suse.de>
 <Pine.LNX.4.64.0705181112250.11881@schroedinger.engr.sgi.com>
 <20070519012530.GB15569@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007, Nick Piggin wrote:

> Hugh points out that we should make _count and _mapcount atomic_long_t's,
> which would probably be a better use of the space once your vmemmap goes
> in.

Well Andy was going to merge it:

http://marc.info/?l=linux-kernel&m=117620162415620&w=2

Andy when are we going to get the vmemmap patches into sparsemem?

