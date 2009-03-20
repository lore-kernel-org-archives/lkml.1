Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbZCTMGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbZCTMGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 08:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZCTMGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 08:06:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:35003 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbZCTMGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 08:06:33 -0400
Subject: Re: [git-pull -tip] x86: mpparse cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1237536134.2494.5.camel@ht.satnam>
References: <1237314836.3212.10.camel@localhost.localdomain>
	 <1237380351.3042.0.camel@ht.satnam> <20090318141115.GA23034@elte.hu>
	 <1237392355.12866.2.camel@ht.satnam>  <20090318161829.GC21331@elte.hu>
	 <1237536134.2494.5.camel@ht.satnam>
Content-Type: text/plain
Date: Fri, 20 Mar 2009 17:35:50 +0530
Message-Id: <1237550750.4518.0.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 13:32 +0530, Jaswinder Singh Rajput wrote:
> On Wed, 2009-03-18 at 17:18 +0100, Ingo Molnar wrote:
> 
> > Looks good - pulled, thanks Jaswinder!
> > 
> > Would you be interested in resurrecting the more mechanic cleanups 
> > you did as well, on top of this patch?
> > 
> > They are still valuable, we just have to keep them separate from a 
> > potential breakage-causing change like the above one, so that if a 
> > tester bisects to it, we have an as single-purpose and focused 
> > commit to look at as possible.
> > 
> 
> cleanup without code change: based on tip:x86/core or x86/cleanups
> or .. ?
> 
> cleanup with code change: based on tip:x86/core or x86/cleanups or .. ?
> 

Yes, now changes reflect on tip:x86/core

--
JSR

