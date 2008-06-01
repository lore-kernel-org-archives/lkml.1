Return-Path: <linux-kernel-owner+w=401wt.eu-S1756984AbYFAJlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984AbYFAJlo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 05:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYFAJlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 05:41:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799AbYFAJlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 05:41:35 -0400
Date: Sun, 1 Jun 2008 02:41:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>, Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k libc5 regression
Message-Id: <20080601024105.b350d1b7.akpm@linux-foundation.org>
In-Reply-To: <20080601092205.GA18045@uranus.ravnborg.org>
References: <Pine.LNX.4.64.0805262226280.11902@anakin>
	<Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz>
	<20080601005338.3affe880.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0806011035420.5559@anakin>
	<20080601014824.528173bb.akpm@linux-foundation.org>
	<20080601092205.GA18045@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2008 11:22:05 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:

> On Sun, Jun 01, 2008 at 01:48:24AM -0700, Andrew Morton wrote:
> > On Sun, 1 Jun 2008 10:37:59 +0200 (CEST) Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > 
> > > > I shall merge this fix into my tree (y'know - the one where memory
> > > > management patches are hosted) and I'll get it into 2.6.26 and shall
> > > > offer it to the -stable team.  This will cause me to get collisions
> > > > with the duplicated patch in linux-next but fortunately it is small. 
> > > > This time.
> > > 
> > > So what's the appropriate way to handle this?
> > 
> > Well at least please reply letting people know what's happening with it.
> > 
> > Ask me to merge it and remind me that it's needed in -stable.  Or just
> > send the thing to Linus and -stable immediately.
> 
> I recall adding:
> Cc: stable@kernel.org
> 
> will automagically tell the stable team when this is
> merged and that it is a -stable candidate.
> 

Yup.  Except I always use the <> wrappers around the email address.  In
fact my scripts require that (and probably shouldn't).  We don't seem
very consistent with that.
