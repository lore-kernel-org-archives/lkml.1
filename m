Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbXBNTCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbXBNTCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbXBNTCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:02:19 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:47355 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932454AbXBNTCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:02:18 -0500
Date: Wed, 14 Feb 2007 11:02:01 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Hugh Dickins <hugh@veritas.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       tony.luck@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] build error: allnoconfig fails on mincore/swapper_space
In-Reply-To: <45D266E3.4050905@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0702141100470.975@schroedinger.engr.sgi.com>
References: <20070212145040.c3aea56e.randy.dunlap@oracle.com>
 <20070212150802.f240e94f.akpm@linux-foundation.org> <45D12715.4070408@yahoo.com.au>
 <20070213121217.0f4e9f3a.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0702132224280.3729@blonde.wat.veritas.com>
 <20070213144909.70943de2.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0702140009320.21315@blonde.wat.veritas.com>
 <45D266E3.4050905@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007, Nick Piggin wrote:

> Can't you have migration without swap?

Yes you can.

