Return-Path: <linux-kernel-owner+w=401wt.eu-S932416AbZKXJVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbZKXJVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932299AbZKXJVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:21:48 -0500
Received: from baikonur.stro.at ([213.239.196.228]:48382 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222AbZKXJVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:21:47 -0500
Date: Tue, 24 Nov 2009 10:15:47 +0100
From: maximilian attems <max@stro.at>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       =?iso-8859-1?Q?An=EDbal?= Monsalve Salazar <anibal@debian.org>,
       Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] kbuild: Steppeing down as Maintainer
Message-ID: <20091124091547.GW25768@baikonur.stro.at>
References: <20091120182249.GA28251@merkur.ravnborg.org> <20091120182613.GA28307@merkur.ravnborg.org> <20091123150524.5bd37f6b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123150524.5bd37f6b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 03:05:24PM -0800, Andrew Morton wrote:
> 
> The current queue is:
> 
> kbuild-generate-modulesbuiltin.patch
> kbuild-rebuild-fix-for-makefilemodbuiltin.patch
> kbuild-generate-modulesbuiltin-fix-2.patch
> kbuild-generate-modulesbuiltin-fix-2-checkpatch-fixes.patch
> kconfig-cross_compile-option.patch
> kbuild-clean-up-marker.patch
> kbuild-clear-marker-out-of-modpost.patch
> kbuild-genksyms-properly-consider-export_unused_symbol_gpl.patch
> 
> 

please add the following fakeroot usage to -next for 2.6.33 as
package target enhancement:
http://marc.info/?l=linux-kbuild&m=125561337922614&w=2
http://marc.info/?l=linux-kbuild&m=125561358622933&w=2

patch got tested inbetween and with both acks:
Acked-by: Frans Pop <elendil@planet.nl>
Acked-by: maximilian attems <max@stro.at>
see http://marc.info/?l=linux-kbuild&m=125551864712151&w=2

thanks
