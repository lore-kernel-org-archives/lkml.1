Return-Path: <linux-kernel-owner+w=401wt.eu-S965524AbXHMDGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965524AbXHMDGu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 23:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765965AbXHMDGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 23:06:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759811AbXHMDGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 23:06:41 -0400
Date: Sun, 12 Aug 2007 23:06:32 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, dean@arctic.org, patches@x86-64.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [1/12] x86: Work around mmio config space quirk on AMD
	Fam10h
Message-ID: <20070813030632.GA1445@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <ak@suse.de>, dean@arctic.org, patches@x86-64.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070809241.425881000@suse.de> <20070809124128.886BE14F3B@wotan.suse.de> <alpine.LFD.0.999.0708120216470.30176@woody.linux-foundation.org> <200708121203.23741.ak@suse.de> <alpine.LFD.0.999.0708121205210.30176@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708121205210.30176@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 12:15:26PM -0700, Linus Torvalds wrote:

 > Bugs happen, but (a) they should happen during the merge window, not when 
 > we're in stabilization phase and (b) the percentages here were just not 
 > very good.

This does make me wonder, why these weren't caught in -mm ?
Andrew lines up Andi's quilt series in each run afaik, or was
the last patchbombing all stuff that bypassed -mm for some reason?

	Dave

-- 
http://www.codemonkey.org.uk
