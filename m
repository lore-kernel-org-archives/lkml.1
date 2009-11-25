Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbZKYTwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbZKYTwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 14:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932238AbZKYTwC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 14:52:02 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759591AbZKYTwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 14:52:01 -0500
Date: Wed, 25 Nov 2009 11:50:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: maximilian attems <max@stro.at>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       =?ISO-8859-1?Q?An=EDbal?= Monsalve Salazar <anibal@debian.org>,
       Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>,
       Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: [PATCH] kbuild: Steppeing down as Maintainer
Message-Id: <20091125115042.8fc70093.akpm@linux-foundation.org>
In-Reply-To: <20091124091547.GW25768@baikonur.stro.at>
References: <20091120182249.GA28251@merkur.ravnborg.org>
	<20091120182613.GA28307@merkur.ravnborg.org>
	<20091123150524.5bd37f6b.akpm@linux-foundation.org>
	<20091124091547.GW25768@baikonur.stro.at>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 10:15:47 +0100
maximilian attems <max@stro.at> wrote:

> On Mon, Nov 23, 2009 at 03:05:24PM -0800, Andrew Morton wrote:
> > 
> > The current queue is:
> > 
> > kbuild-generate-modulesbuiltin.patch
> > kbuild-rebuild-fix-for-makefilemodbuiltin.patch
> > kbuild-generate-modulesbuiltin-fix-2.patch
> > kbuild-generate-modulesbuiltin-fix-2-checkpatch-fixes.patch
> > kconfig-cross_compile-option.patch
> > kbuild-clean-up-marker.patch
> > kbuild-clear-marker-out-of-modpost.patch
> > kbuild-genksyms-properly-consider-export_unused_symbol_gpl.patch
> > 
> > 
> 
> please add the following fakeroot usage to -next for 2.6.33 as
> package target enhancement:
> http://marc.info/?l=linux-kbuild&m=125561337922614&w=2
> http://marc.info/?l=linux-kbuild&m=125561358622933&w=2

I don't have a copy.

> patch got tested inbetween and with both acks:
> Acked-by: Frans Pop <elendil@planet.nl>
> Acked-by: maximilian attems <max@stro.at>
> see http://marc.info/?l=linux-kbuild&m=125551864712151&w=2

Please refresh, retest and resend.  Update the acks in the changelog, thanks.
