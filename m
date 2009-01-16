Return-Path: <linux-kernel-owner+w=401wt.eu-S937192AbZAPUp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937192AbZAPUp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 15:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbZAPUpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 15:45:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248AbZAPUpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 15:45:13 -0500
Date: Fri, 16 Jan 2009 12:44:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: roland@redhat.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trailing whitespace in kernel/ptrace.c
Message-Id: <20090116124452.7bbc77bc.akpm@linux-foundation.org>
In-Reply-To: <20090115221135.GA10283@elte.hu>
References: <20090115205751.B5F6EFC3DD@magilla.sf.frob.com>
	<20090115221135.GA10283@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 23:11:35 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Roland McGrath <roland@redhat.com> wrote:
> 
> > These bug me every time I want to touch ptrace.c, nix them.
> > 
> > Signed-off-by: Roland McGrath <roland@redhat.com>
> > ---
> >  kernel/ptrace.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> btw., here's the checkpatch output from that file:

Yes, we might as well fix all of them while we're there.

> WARNING: line over 80 characters
> WARNING: line over 80 characters
> WARNING: line over 80 characters

but maybe not those.
