Return-Path: <linux-kernel-owner+w=401wt.eu-S1759935AbYD2P3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759935AbYD2P3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYD2P25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:28:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44512 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbYD2P25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:28:57 -0400
Date: Tue, 29 Apr 2008 11:28:45 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frans Pop <elendil@planet.nl>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Richard Jonsson <richie@coderworld.net>
Subject: Re: [git pull] scheduler changes for v2.6.26
In-Reply-To: <20080429122903.GG31271@elte.hu>
Message-ID: <Pine.LNX.4.58.0804291128350.20698@gandalf.stny.rr.com>
References: <20080419181304.GB21353@elte.hu> <200804231136.50639.elendil@planet.nl>
 <20080423094644.GB23293@elte.hu> <200804231536.03076.elendil@planet.nl>
 <20080429122903.GG31271@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 29 Apr 2008, Ingo Molnar wrote:

>
> * Frans Pop <elendil@planet.nl> wrote:
>
> > P.S. It would probably be good to just mention the units in the
> > headers of the debug files. It may be obvious to you, but that way
> > it's obvious even to morons like me :-P
>
> yeah, agreed. We did that in -rt's /proc/latency_trace but it isnt there
> in ftrace. Steve?

Yep, I'll make a patch.

-- Steve

