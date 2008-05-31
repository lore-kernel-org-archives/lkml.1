Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYEaAse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYEaAse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbYEaAs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:48:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbYEaAs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:48:26 -0400
Date: Fri, 30 May 2008 20:41:11 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Top kernel oopses/warnings for the week of May 30th 2008
Message-ID: <20080531004110.GA24795@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Hugh Dickins <hugh@veritas.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
	Jeff Garzik <jeff@garzik.org>
References: <48402DAA.60202@linux.intel.com> <Pine.LNX.4.64.0805302017580.16427@blonde.site> <alpine.LFD.1.10.0805301403540.3141@woody.linux-foundation.org> <48407909.5090608@linux.intel.com> <alpine.LFD.1.10.0805301517500.3141@woody.linux-foundation.org> <484080EC.9090707@linux.intel.com> <alpine.LFD.1.10.0805301547040.3141@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805301547040.3141@woody.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2008 at 03:55:25PM -0700, Linus Torvalds wrote:
 > 
 > 
 > On Fri, 30 May 2008, Arjan van de Ven wrote:
 > > 
 > > versions that do identify themselves as "2.6.25-14.fc9.i686.PAE", and 
 > > these ones didn't, (they're all in the "2.6.25-14.fc9.i686" form) so 
 > > this is a kernel without PAE.
 > 
 > Hmm. Every single one is that one kernel version or 2.6.25.3-18.fc9.i686, 
 > and with that many reports I'd have expected it from other kernels too. 
 > What was the previous popular fc9 kernel (I assume it was 2.6.25-based 
 > too?), and what changed?

-14 is the version that we released F9 with, which explains its popularity.
-18 was the first update we pushed out within the first few days..

The earlier f9 builds were only beaten on by people testing our development
tree, which is nowhere near as many as what jump on a proper release.

	Dave

-- 
http://www.codemonkey.org.uk
