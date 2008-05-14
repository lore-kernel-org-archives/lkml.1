Return-Path: <linux-kernel-owner+w=401wt.eu-S1759098AbYENQTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098AbYENQTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 12:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYENQTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 12:19:05 -0400
Received: from mail.queued.net ([207.210.101.209]:1923 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbYENQTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 12:19:04 -0400
Date: Wed, 14 May 2008 12:23:19 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       rdunlap@xenotime.net, jschopp@austin.ibm.com
Subject: Re: [PATCH] checkpatch: update the 80-char-line check to allow for
 long strings
Message-ID: <20080514122319.054d9aaa@ephemeral>
In-Reply-To: <20080514155926.GF2821@shadowen.org>
References: <20080514005325.765178fc@ephemeral>
	<1210751346.10126.8.camel@twins>
	<20080514104938.4b16c735@ephemeral>
	<20080514155926.GF2821@shadowen.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 16:59:26 +0100
Andy Whitcroft <apw@shadowen.org> wrote:

> On Wed, May 14, 2008 at 10:49:38AM -0400, Andres Salomon wrote:
> > On Wed, 14 May 2008 09:49:06 +0200
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
[...]
> > 
> > The point is that we tell people to make sure that their patches are
> > checkpatch-clean.  Let's make the tool reflect what we're actually
> > looking for.
> 
> We did have a mini discussion on this when Ingo suggested allowing the
> strings to run off the end of the line so that grep would work.  I did
> put together a patch then for this.  There was no real response to the
> suggestion we should take that recommendation into CodingStyle and
> thus into checkpatch.
> 
> -apw

I've yet to hear anyone say that this idea is awful...
