Return-Path: <linux-kernel-owner+w=401wt.eu-S1758354AbYGGXAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354AbYGGXAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 19:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbYGGXAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 19:00:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:48336 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372AbYGGXAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 19:00:23 -0400
Subject: Re: Deputy maintainer for powerpc
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       lkml List <linux-kernel@vger.kernel.org>
In-Reply-To: <20080707152548.5075845f@zod.rchland.ibm.com>
References: <18541.48403.490671.815858@cargo.ozlabs.ibm.com>
	 <155B1079-39C4-4D15-B886-F904C424BC8C@kernel.crashing.org>
	 <20080707152548.5075845f@zod.rchland.ibm.com>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 08:58:53 +1000
Message-Id: <1215471533.8970.160.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-07 at 15:25 -0400, Josh Boyer wrote:
> > Ben, Do you have a tree that you'll be using to collect things in?
> 
> I hope it's the same tree for this merge window.

It's in a different place but it's essentially the same tree (ie, I
pulled in paulus branches and my current heads are identical, at least
until I start adding things to it).

> In the future, I hope the semantics of the various branches of the
> new tree either stays the same, or comes with a detailed description
> of what branch means what (assuming there is a new tree at some
> point).

Branches are the same, master,merge and next (the only subtle difference
is that my next branch is called just "next" and not "powerpc-next").

Ben.


