Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbXJ0XJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbXJ0XJM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 19:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbXJ0XI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 19:08:58 -0400
Received: from phunq.net ([64.81.85.152]:56323 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751390AbXJ0XI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 19:08:58 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC 0/3] Recursive reclaim (on __PF_MEMALLOC)
Date: Sat, 27 Oct 2007 16:08:50 -0700
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dkegel@google.com, David Miller <davem@davemloft.net>,
       Nick Piggin <npiggin@suse.de>
References: <Pine.LNX.4.64.0709101220001.24735@schroedinger.engr.sgi.com> <1189457286.21778.68.camel@twins> <20071026174409.GA1573@elf.ucw.cz>
In-Reply-To: <20071026174409.GA1573@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710271608.50973.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2007 10:44, Peter wrote:
> > ...the way the watermarks work they will be evenly distributed
> > over the appropriate zones. ..

Hi Peter,

The term is "highwater mark" not "high watermark".  A watermark is an 
anti-counterfeiting device printed on paper money.  "Highwater" is how 
high water gets, which I believe is the sense we intend in Linux.  
Therefore any occurrence of "watermark" in the kernel source is a 
spelling mistake, unless it has something to do with printing paper 
money.

While fixing this entrenched terminology abuse in our kernel source may 
be difficult, sticking to the correct English on lkml is quite easy :-)

Regards,

Daniel
