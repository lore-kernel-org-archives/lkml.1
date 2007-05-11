Return-Path: <linux-kernel-owner+w=401wt.eu-S1761206AbXEKUrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761206AbXEKUrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758857AbXEKUrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:47:13 -0400
Received: from holomorphy.com ([66.93.40.71]:35661 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbXEKUrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:47:12 -0400
Date: Fri, 11 May 2007 13:47:47 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: slub-i386-support.patch
Message-ID: <20070511204747.GU19966@holomorphy.com>
References: <Pine.LNX.4.64.0705102028550.25681@blonde.wat.veritas.com> <20070510203102.GO19966@holomorphy.com> <Pine.LNX.4.64.0705102349150.24200@blonde.wat.veritas.com> <20070511082930.GP2012@bingen.suse.de> <20070511004200.6d30152e.akpm@linux-foundation.org> <20070511075410.GT19966@holomorphy.com> <Pine.LNX.4.64.0705110914000.19153@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705110914000.19153@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007, William Lee Irwin III wrote:
>> Christoph wants to update the core quicklist code or have me update
>> it according to the cached precomputed value scheme I outlined in a
>> prior post before its initial merge. I'll prepare all the patches for
>> comment regardless.

On Fri, May 11, 2007 at 09:15:58AM -0700, Christoph Lameter wrote:
> I am fine with you updating the quicklist code since I have currently no 
> plans on doing more there. Just be sure to coordinate with all quicklists 
> users please.

No problem. I do sweep all arches as a matter of course.


-- wli
