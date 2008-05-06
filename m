Return-Path: <linux-kernel-owner+w=401wt.eu-S1760920AbYEFDFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920AbYEFDFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 23:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbYEFDFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 23:05:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752311AbYEFDFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 23:05:21 -0400
Date: Mon, 5 May 2008 20:05:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 02/18] flag parameters: socket and socketpair
Message-Id: <20080505200500.0d1018df.akpm@linux-foundation.org>
In-Reply-To: <481FC94C.8090203@redhat.com>
References: <200805050342.m453gktl029817@devserv.devel.redhat.com>
	<20080505185850.789d870a.akpm@linux-foundation.org>
	<481FC38A.6070805@redhat.com>
	<20080505194221.4349418b.akpm@linux-foundation.org>
	<481FC94C.8090203@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 May 2008 19:58:20 -0700 Ulrich Drepper <drepper@redhat.com> wrote:

> Andrew Morton wrote:
> > Sorry to sound slow, but what do we gain from all this?  Your covering
> > description was heavy in references to some earlier discussion to which I
> > obviously paid little attention and now I'm lost.
> 
> What we gain is that the only change for a new flag is a new entry in
> the appropriate table.  The reference to non-sequential file descriptors
> refers to
> 
>   http://lwn.net/Articles/236724/

What I meant was "what does this whole patchset do"?  Believe it or not,
for a new reader, that is somewhat unobvious.  Perhaps one could work it out
with sufficient googling and thread-trolling.

