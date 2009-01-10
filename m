Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbZAJUkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbZAJUkb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 15:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZAJUkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 15:40:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62950 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbZAJUkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 15:40:21 -0500
Date: Sat, 10 Jan 2009 15:40:16 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Theodore Tso <tytso@mit.edu>
cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       ltt-dev@lists.casi.polymtl.ca,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [ltt-dev] Fw: [PATCH] ext4: Add markers for better
 debuggability
In-Reply-To: <20090110184240.GA31579@mit.edu>
Message-ID: <alpine.DEB.1.10.0901101539230.32218@gandalf.stny.rr.com>
References: <20090109170408.75C1.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090109144901.GA7262@Krystal> <20090109185840.GD23869@mit.edu> <20090110161906.GB20526@Krystal> <20090110184240.GA31579@mit.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 10 Jan 2009, Theodore Tso wrote:
> 
> P.S.  At the kernel summit, there was some talk about a very
> simplified interface that would allow us to extract text dumps from
> tracepoints without having to download a huge userspace utility like
> SystemTap --- or LTTng.  Has that been written yet, or is the only way
> for me to use Tracepoints right now is to figure out how to use the
> whole LTTng infrstructure?

Actually, that's one of the things ftrace is suppose to do, and is on my 
todo list. To track all trace points, and be able to hook into any one and 
print them out to the trace.

-- Steve

