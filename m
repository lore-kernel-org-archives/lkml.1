Return-Path: <linux-kernel-owner+w=401wt.eu-S1758360AbYFYPIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360AbYFYPIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYFYPHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:07:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36811 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbYFYPHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:07:52 -0400
Subject: Re: [PATCH 6/6] futex: fix miss ordered wakeups
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1214404611.21035.20.camel@localhost.localdomain>
References: <20080624232018.817822790@mvista.com>
	 <20080624232020.505470899@mvista.com>  <1214371767.16881.5.camel@twins>
	 <1214404611.21035.20.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 25 Jun 2008 17:07:31 +0200
Message-Id: <1214406451.24356.13.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-25 at 07:36 -0700, Daniel Walker wrote:
> On Wed, 2008-06-25 at 07:29 +0200, Peter Zijlstra wrote:
> 
> > Daniel, I'm not sure what to think,.. you were told how broken this
> > approach was, you were told to give proper justification for this
> > change. You did neither and just reposted the same old broken shite
> > again.
> 
> Broken approach ? Never heard that before, 

I suggest you re-read some of Thomas' emails from last time...

  http://lkml.org/lkml/2008/6/12/275

> in fact the problem is
> whether or not the changes are needed (not weather their broken).. I
> gave justification in the last thread, and I'm not sure why it's unclear
> to you..

You failed to convince, also justification goes in the changelog, not in
random lkml threads.



