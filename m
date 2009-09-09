Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbZIILq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbZIILq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 07:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZIILq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 07:46:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57394 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbZIILq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 07:46:27 -0400
Subject: Re: [PATCH 2/2] tracing/events: Add kexec tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Daniel Walker <dwalker@fifo99.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Eric Biederman <ebiederm@xmission.com>
In-Reply-To: <1252472376.14793.85.camel@desktop>
References: <4AA70198.9070500@cn.fujitsu.com>  <4AA701B3.704@cn.fujitsu.com>
	 <1252459241.14793.40.camel@desktop>  <4AA70451.6050307@cn.fujitsu.com>
	 <1252472376.14793.85.camel@desktop>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 09 Sep 2009 07:46:28 -0400
Message-Id: <1252496788.27001.0.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 21:59 -0700, Daniel Walker wrote:
> On Wed, 2009-09-09 at 09:26 +0800, Li Zefan wrote:
> > Daniel Walker wrote:
> > > On Wed, 2009-09-09 at 09:15 +0800, Li Zefan wrote:
> > >> +       TP_STRUCT__entry(
> > >> +               __string(       msg,    msg     )
> > >> +       ),
> > > 
> > > Why the funny spacing here?
> > > 
> > 
> > To make the code better-looking.
> > 
> > This is the coding-style we use for the code in
> > include/trace/events/*.
> 
> It's part of Linux right? We already have a coding style ..

It's a special macro. What are you now, part of the style police?

-- Steve


