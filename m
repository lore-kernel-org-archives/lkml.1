Return-Path: <linux-kernel-owner+w=401wt.eu-S1761565AbYENOp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761565AbYENOp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYENOpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:45:20 -0400
Received: from mail.queued.net ([207.210.101.209]:3826 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbYENOpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:45:19 -0400
Date: Wed, 14 May 2008 10:49:38 -0400
From: Andres Salomon <dilinger@queued.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, mingo@elte.hu, rdunlap@xenotime.net,
       jschopp@austin.ibm.com
Subject: Re: [PATCH] checkpatch: update the 80-char-line check to allow for
 long strings
Message-ID: <20080514104938.4b16c735@ephemeral>
In-Reply-To: <1210751346.10126.8.camel@twins>
References: <20080514005325.765178fc@ephemeral>
	<1210751346.10126.8.camel@twins>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 09:49:06 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2008-05-14 at 00:53 -0400, Andres Salomon wrote:
> > 19:29 * dilinger sends his patch to lkml for a proper flaming
> > 19:32  Quozl> dilinger: it's called "patch hardening"?  ;-}  the
> > heat of the flames makes the patch stronger.
> > 
> > I've wasted too much time massaging printk strings in order to
> > satisfy checkpatch.pl.  Comments on this?
> 
> How about treating like its meant to be; as a guide instead of a hard
> rule. That means you can ignore it with good taste.. :-)
> 
> 

The point is that we tell people to make sure that their patches are
checkpatch-clean.  Let's make the tool reflect what we're actually
looking for.
