Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbYE3W4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbYE3W4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 18:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbYE3W41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 18:56:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754206AbYE3W40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 18:56:26 -0400
Date: Fri, 30 May 2008 15:55:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Top kernel oopses/warnings for the week of May 30th 2008
In-Reply-To: <484080EC.9090707@linux.intel.com>
Message-ID: <alpine.LFD.1.10.0805301547040.3141@woody.linux-foundation.org>
References: <48402DAA.60202@linux.intel.com> <Pine.LNX.4.64.0805302017580.16427@blonde.site> <alpine.LFD.1.10.0805301403540.3141@woody.linux-foundation.org> <48407909.5090608@linux.intel.com> <alpine.LFD.1.10.0805301517500.3141@woody.linux-foundation.org>
 <484080EC.9090707@linux.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 May 2008, Arjan van de Ven wrote:
> 
> versions that do identify themselves as "2.6.25-14.fc9.i686.PAE", and 
> these ones didn't, (they're all in the "2.6.25-14.fc9.i686" form) so 
> this is a kernel without PAE.

Hmm. Every single one is that one kernel version or 2.6.25.3-18.fc9.i686, 
and with that many reports I'd have expected it from other kernels too. 
What was the previous popular fc9 kernel (I assume it was 2.6.25-based 
too?), and what changed?

		Linus
