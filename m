Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbYCKU4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbYCKU4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 16:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbYCKU4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 16:56:45 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:42171 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbYCKU4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 16:56:44 -0400
Date: Tue, 11 Mar 2008 13:45:17 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: P6 NOPs again: MPSC?
In-Reply-To: <20080311092843.GO25110@elte.hu>
Message-ID: <Pine.LNX.4.64.0803111343490.22181@blonde.site>
References: <Pine.LNX.4.64.0803041929230.14934@blonde.site>
 <20080304210111.GB31546@elte.hu> <47CDBE09.3060000@zytor.com>
 <Pine.LNX.4.64.0803101853090.15511@blonde.site> <47D59743.7040709@zytor.com>
 <Pine.LNX.4.64.0803102142440.2464@blonde.site> <20080311092843.GO25110@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008, Ingo Molnar wrote:
> * Hugh Dickins <hugh@veritas.com> wrote:
> 
> > (But I've lost my way around here.  A good example of the 32/64 
> > confusion is how one has to remember that X86_GENERIC is peculiar to 
> > 32-bit, and CPU_GENERIC peculiar to 64-bit.  And CPU_GENERIC is 
> > understandably an alternative to the specific 64-bit models, but 
> > X86_GENERIC is strangely in addition to the specific 32-bit models.)
> 
> yes - this is one of the arbitrary deviations between 32-bit and 64-bit. 
> Patches to bring the concepts and names in sync are welcome :-)

:-)  I durst not!

Hugh
