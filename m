Return-Path: <linux-kernel-owner+w=401wt.eu-S934228AbZJGPw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934228AbZJGPw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934200AbZJGPw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:52:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38835 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934195AbZJGPwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:52:25 -0400
Date: Wed, 7 Oct 2009 16:52:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Andy Whitcroft <apw@canonical.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/5] checkpatch: add a blacklist
Message-ID: <20091007165250.30d8c996@lxorguk.ukuu.org.uk>
In-Reply-To: <1254930068.18167.304.camel@desktop>
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
	<20091007161107.72b4031b@lxorguk.ukuu.org.uk>
	<1254930068.18167.304.camel@desktop>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Oct 2009 08:41:08 -0700
Daniel Walker <dwalker@fifo99.com> wrote:

> On Wed, 2009-10-07 at 16:11 +0100, Alan Cox wrote:
> > > Right it's a tool .. However, you should use it and you should follow
> > > it. If for some reason you disagree with the tool you have to give at
> > > least an arguable reason why, not just "It's a guide", "I don't like the
> > > coding style." etc..
> > 
> > Those are perfectly good reasons.
> 
> I don't think they are.. Like adding spaces for tabs is ok cause
> checkpatch is a guide right?

Yes.. if it was such a big deal someone would have updated the git commit
tools to fix them as we do to strim off trailing spaces.

They have *zero* impact on performance, maintainability or readability
providing they don't mess up the indentation - and the kernel is full of
them.
