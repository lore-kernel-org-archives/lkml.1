Return-Path: <linux-kernel-owner+w=401wt.eu-S1759455AbZJGO63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455AbZJGO63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759407AbZJGO62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:58:28 -0400
Received: from fifo99.com ([67.223.236.141]:44113 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759341AbZJGO60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:58:26 -0400
Subject: Re: [PATCH 3/5] checkpatch: add a blacklist
From: Daniel Walker <dwalker@fifo99.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Andy Whitcroft <apw@canonical.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <m3skdvtgas.fsf@intrepid.localdomain>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-2-git-send-email-dwalker@fifo99.com>
	 <1253585691-10987-3-git-send-email-dwalker@fifo99.com>
	 <4AB86ED1.1040200@cn.fujitsu.com> <20090930152708.GD2957@shadowen.org>
	 <1254406711.18167.88.camel@desktop> <m33a5ww8kn.fsf@intrepid.localdomain>
	 <1254887534.18167.253.camel@desktop> <m3hbubv779.fsf@intrepid.localdomain>
	 <1254925617.18167.262.camel@desktop>  <m3skdvtgas.fsf@intrepid.localdomain>
Content-Type: text/plain
Date: Wed, 07 Oct 2009 07:57:17 -0700
Message-Id: <1254927438.18167.275.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 16:44 +0200, Krzysztof Halasa wrote:
> Daniel Walker <dwalker@fifo99.com> writes:
> 
> >>From my perspective Documentation/SubmittingPatches really dictates what
> > you should be doing with checkpatch, since that was signed off on by
> > Andy (on this thread) and Linus .. In that document I think checkpatch
> > is given authority, rather than what your suggesting where it's just
> > something you can use or not, and ignore or not like it has no meaning
> > at all..
> 
> Checkpatch is a tool. How a tool can have authority? Code authors can
> have authority. Maintainers can have authority. Linus as the "top"
> maintainer can have authority. But a tool?
> 
> If checkpatch had any authority, the file in question (ext4.h) would
> have to be "fixed" without questions and exceptions.
> 
> I don't say its warnings and errors have no meaning at all. It may be
> very helpful at times, but still it's only a tool.

Right it's a tool .. However, you should use it and you should follow
it. If for some reason you disagree with the tool you have to give at
least an arguable reason why, not just "It's a guide", "I don't like the
coding style." etc..

In the case of Steven's code he has an arguable reason why he's not
following checkpatch..

Daniel

