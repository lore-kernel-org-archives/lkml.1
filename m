Return-Path: <linux-kernel-owner+w=401wt.eu-S1759322AbZJGO2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322AbZJGO2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759268AbZJGO2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:28:04 -0400
Received: from fifo99.com ([67.223.236.141]:53706 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759227AbZJGO2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:28:03 -0400
Subject: Re: [PATCH 3/5] checkpatch: add a blacklist
From: Daniel Walker <dwalker@fifo99.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Andy Whitcroft <apw@canonical.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <m3hbubv779.fsf@intrepid.localdomain>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
	 <4AB86ED1.1040200@cn.fujitsu.com> <20090930152708.GD2957@shadowen.org>
	 <1254406711.18167.88.camel@desktop> <m33a5ww8kn.fsf@intrepid.localdomain>
	 <1254887534.18167.253.camel@desktop>  <m3hbubv779.fsf@intrepid.localdomain>
Content-Type: text/plain
Date: Wed, 07 Oct 2009 07:26:57 -0700
Message-Id: <1254925617.18167.262.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 12:17 +0200, Krzysztof Halasa wrote:
> Daniel Walker <dwalker@fifo99.com> writes:
> 
> > This thread is specifically about checkpatch errors .. checkpatch
> > warnings can be ignored, but errors you can't usually ignore..
> 
> Of course I can and do :-)
> 
> > If your
> > ignoring errors then either checkpatch is producing bogus output that
> > needs to be corrected, or it's something you really should fix..
> 
> Neither.
> But unfortunately I don't have examples handy.
> 
> My POV must be a bit different: I treat errors like another class of
> warnings (perhaps more important that "mere" warnings but still not
> authoritative).

>From my perspective Documentation/SubmittingPatches really dictates what
you should be doing with checkpatch, since that was signed off on by
Andy (on this thread) and Linus .. In that document I think checkpatch
is given authority, rather than what your suggesting where it's just
something you can use or not, and ignore or not like it has no meaning
at all..

Daniel

