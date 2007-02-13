Return-Path: <linux-kernel-owner+w=401wt.eu-S1751602AbXBMSvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbXBMSvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 13:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbXBMSvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 13:51:08 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:39172 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751606AbXBMSvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 13:51:07 -0500
Date: Tue, 13 Feb 2007 10:50:53 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: "Martin J. Bligh" <mbligh@mbligh.org>
cc: Andi Kleen <ak@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       bob.picco@hp.com
Subject: Re: [RFC] [PATCH] more support for memory-less-node.
In-Reply-To: <45D20067.2090803@mbligh.org>
Message-ID: <Pine.LNX.4.64.0702131050340.26654@schroedinger.engr.sgi.com>
References: <20070213155736.1131d46a.kamezawa.hiroyu@jp.fujitsu.com>
 <45D1F0B1.3020508@mbligh.org> <200702131845.05913.ak@suse.de>
 <Pine.LNX.4.64.0702130956540.26309@schroedinger.engr.sgi.com>
 <45D20067.2090803@mbligh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007, Martin J. Bligh wrote:

> What's wrong with just setting the existing counters like
> node_spanned_pages / node_present_pages to zero?

Will this fix the breakage that Kame-san saw?

