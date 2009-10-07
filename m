Return-Path: <linux-kernel-owner+w=401wt.eu-S1759176AbZJGOox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176AbZJGOox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZJGOow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:44:52 -0400
Received: from khc.piap.pl ([195.187.100.11]:55272 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbZJGOov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:44:51 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Andy Whitcroft <apw@canonical.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/5] checkpatch: add a blacklist
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
	<1253585691-10987-2-git-send-email-dwalker@fifo99.com>
	<1253585691-10987-3-git-send-email-dwalker@fifo99.com>
	<4AB86ED1.1040200@cn.fujitsu.com> <20090930152708.GD2957@shadowen.org>
	<1254406711.18167.88.camel@desktop>
	<m33a5ww8kn.fsf@intrepid.localdomain>
	<1254887534.18167.253.camel@desktop>
	<m3hbubv779.fsf@intrepid.localdomain>
	<1254925617.18167.262.camel@desktop>
Date: Wed, 07 Oct 2009 16:44:11 +0200
In-Reply-To: <1254925617.18167.262.camel@desktop> (Daniel Walker's message of
	"Wed, 07 Oct 2009 07:26:57 -0700")
Message-ID: <m3skdvtgas.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker <dwalker@fifo99.com> writes:

>>From my perspective Documentation/SubmittingPatches really dictates what
> you should be doing with checkpatch, since that was signed off on by
> Andy (on this thread) and Linus .. In that document I think checkpatch
> is given authority, rather than what your suggesting where it's just
> something you can use or not, and ignore or not like it has no meaning
> at all..

Checkpatch is a tool. How a tool can have authority? Code authors can
have authority. Maintainers can have authority. Linus as the "top"
maintainer can have authority. But a tool?

If checkpatch had any authority, the file in question (ext4.h) would
have to be "fixed" without questions and exceptions.

I don't say its warnings and errors have no meaning at all. It may be
very helpful at times, but still it's only a tool.
-- 
Krzysztof Halasa
