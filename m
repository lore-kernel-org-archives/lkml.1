Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbXLUKbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbXLUKbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 05:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758272AbXLUKaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 05:30:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758155AbXLUKax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 05:30:53 -0500
Subject: Re: [PATCH -mm 01/43] user_regset header
From: Peter Zijlstra <pzijlstr@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20071221084400.690CE26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
	 <20071220115357.D1E1326F98A@magilla.localdomain>
	 <20071221070650.GA4345@infradead.org>
	 <20071221084400.690CE26F98A@magilla.localdomain>
Content-Type: text/plain
Date: Fri, 21 Dec 2007 11:26:01 +0100
Message-Id: <1198232761.14461.29.camel@taijtu>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-21 at 00:44 -0800, Roland McGrath wrote:
> > What's a Red Hat Author?  Sorry for the nitpicking, but why don't you
> > just use Author like everyone else?
> 
> This text is the standard that my employer specifies.

I can't remember seeing anyone else doing this, and there are plenty of
us around.

I usually use:

 *  Copyright (C) 2007 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>



