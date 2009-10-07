Return-Path: <linux-kernel-owner+w=401wt.eu-S1759380AbZJGPL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380AbZJGPL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZJGPL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:11:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40407 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751204AbZJGPL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:11:27 -0400
Date: Wed, 7 Oct 2009 16:11:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Andy Whitcroft <apw@canonical.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/5] checkpatch: add a blacklist
Message-ID: <20091007161107.72b4031b@lxorguk.ukuu.org.uk>
In-Reply-To: <1254927438.18167.275.camel@desktop>
References: <1253585691-10987-1-git-send-email-dwalker@fifo99.com>
	<1253585691-10987-2-git-send-email-dwalker@fifo99.com>
	<1253585691-10987-3-git-send-email-dwalker@fifo99.com>
	<4AB86ED1.1040200@cn.fujitsu.com>
	<20090930152708.GD2957@shadowen.org>
	<1254406711.18167.88.camel@desktop>
	<m33a5ww8kn.fsf@intrepid.localdomain>
	<1254887534.18167.253.camel@desktop>
	<m3hbubv779.fsf@intrepid.localdomain>
	<1254925617.18167.262.camel@desktop>
	<m3skdvtgas.fsf@intrepid.localdomain>
	<1254927438.18167.275.camel@desktop>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Right it's a tool .. However, you should use it and you should follow
> it. If for some reason you disagree with the tool you have to give at
> least an arguable reason why, not just "It's a guide", "I don't like the
> coding style." etc..

Those are perfectly good reasons.

> In the case of Steven's code he has an arguable reason why he's not
> following checkpatch..

Checkpatch is not very bright, it has no understanding of style beyond
playing with pattern regexps. It's a rather dim tool that helps people
get work done. (*)

When used at random to "validate" submissions to the kernel the result is
about as useful as a square wheel on a hovercraft.

Alan
(*) or as some would have it a rather dim tool used by even dimmer tools
to make noise on kernel list.
