Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbZIRREt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbZIRREt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 13:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbZIRREt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 13:04:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36841 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbZIRREs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 13:04:48 -0400
Subject: Re: [PATCH tip/core/rcu 2/3] Apply results of code inspection of
 kernel/rcutree_plugin.h
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Walker <dwalker@fifo99.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1253293408.7060.47.camel@desktop>
References: <20090918164955.GA22272@linux.vnet.ibm.com>
	 <12532926201851-git-send-email->  <1253293100.7060.46.camel@desktop>
	 <1253293255.10538.27.camel@laptop>  <1253293408.7060.47.camel@desktop>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 19:04:50 +0200
Message-Id: <1253293490.10538.28.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 10:03 -0700, Daniel Walker wrote:

> > > ERROR: code indent should use tabs where possible
> > > #149: FILE: kernel/rcutree_plugin.h:120:
> > > +^I    ^IWARN_ON_ONCE(!list_empty(&t->rcu_node_entry));$
> > > 
> > > 
> > > One funny indent in the line above.. If your intending for Ingo to take
> > > this he might just fix it on apply ..
> > 
> > Daniel, seriously, get a new hobby.
> 
> 
> I don't get why your so annoyed ..

If we thought a checkpatch bot was a good idea, we'd have asked the list
admins for one.

