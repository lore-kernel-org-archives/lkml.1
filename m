Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbZG0VgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbZG0VgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755112AbZG0VgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:36:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:39396 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074AbZG0VgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:36:03 -0400
Subject: Re: [RFC/PATCH] mm: Pass virtual address to
 [__]p{te,ud,md}_free_tlb()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux-Arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Hugh Dickins <hugh@tiscali.co.uk>
In-Reply-To: <alpine.LFD.2.01.0907271210210.25224@localhost.localdomain>
References: <20090715074952.A36C7DDDB2@ozlabs.org>
	 <20090715135620.GD7298@wotan.suse.de> <1248073873.13067.31.camel@pasglop>
	 <alpine.LFD.2.01.0907220930320.19335@localhost.localdomain>
	 <1248310415.3367.22.camel@pasglop>
	 <alpine.LFD.2.01.0907271210210.25224@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 07:35:35 +1000
Message-Id: <1248730535.23358.1.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 12:11 -0700, Linus Torvalds wrote:
> 
> On Thu, 23 Jul 2009, Benjamin Herrenschmidt wrote:
> > 
> > Hrm... my powerpc-next branch will contain stuff that depend on it, so
> > I'll probably have to pull it in though, unless I tell all my
> > sub-maintainers to also pull from that other branch first :-)
> 
> Ok, I'll just apply the patch. It does look obvious enough.

Thanks. It's been in -next for a day now btw, and afaik, there have been
no issue reported.

Cheers,
Ben.
 

