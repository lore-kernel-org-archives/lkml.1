Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbZG0TLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbZG0TLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 15:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbZG0TLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 15:11:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754265AbZG0TLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 15:11:50 -0400
Date: Mon, 27 Jul 2009 12:11:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Nick Piggin <npiggin@suse.de>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux-Arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Hugh Dickins <hugh@tiscali.co.uk>
Subject: Re: [RFC/PATCH] mm: Pass virtual address to
 [__]p{te,ud,md}_free_tlb()
In-Reply-To: <1248310415.3367.22.camel@pasglop>
Message-ID: <alpine.LFD.2.01.0907271210210.25224@localhost.localdomain>
References: <20090715074952.A36C7DDDB2@ozlabs.org>  <20090715135620.GD7298@wotan.suse.de> <1248073873.13067.31.camel@pasglop>  <alpine.LFD.2.01.0907220930320.19335@localhost.localdomain> <1248310415.3367.22.camel@pasglop>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Jul 2009, Benjamin Herrenschmidt wrote:
> 
> Hrm... my powerpc-next branch will contain stuff that depend on it, so
> I'll probably have to pull it in though, unless I tell all my
> sub-maintainers to also pull from that other branch first :-)

Ok, I'll just apply the patch. It does look obvious enough.

			Linus
