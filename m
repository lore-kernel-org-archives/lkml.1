Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbYGRDDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbYGRDDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 23:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYGRDC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 23:02:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39824 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbYGRDC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 23:02:57 -0400
Date: Thu, 17 Jul 2008 23:02:55 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] tracing fixes
In-Reply-To: <Pine.LNX.4.58.0807172249230.22792@gandalf.stny.rr.com>
Message-ID: <Pine.LNX.4.58.0807172302370.22792@gandalf.stny.rr.com>
References: <20080717173210.GA12828@elte.hu> <Pine.LNX.4.58.0807172249230.22792@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 17 Jul 2008, Steven Rostedt wrote:
>
> also, is the '-mno-spe' save when ftrace is not configured?

s/save/safe/

-- Steve

