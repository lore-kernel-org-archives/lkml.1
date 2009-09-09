Return-Path: <linux-kernel-owner+w=401wt.eu-S1751431AbZIIE7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbZIIE7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 00:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbZIIE7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 00:59:15 -0400
Received: from fifo99.com ([67.223.236.141]:59035 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbZIIE7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 00:59:14 -0400
Subject: Re: [PATCH 2/2] tracing/events: Add kexec tracepoints
From: Daniel Walker <dwalker@fifo99.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Eric Biederman <ebiederm@xmission.com>
In-Reply-To: <4AA70451.6050307@cn.fujitsu.com>
References: <4AA70198.9070500@cn.fujitsu.com>  <4AA701B3.704@cn.fujitsu.com>
	 <1252459241.14793.40.camel@desktop>  <4AA70451.6050307@cn.fujitsu.com>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 21:59:36 -0700
Message-Id: <1252472376.14793.85.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 09:26 +0800, Li Zefan wrote:
> Daniel Walker wrote:
> > On Wed, 2009-09-09 at 09:15 +0800, Li Zefan wrote:
> >> +       TP_STRUCT__entry(
> >> +               __string(       msg,    msg     )
> >> +       ),
> > 
> > Why the funny spacing here?
> > 
> 
> To make the code better-looking.
> 
> This is the coding-style we use for the code in
> include/trace/events/*.

It's part of Linux right? We already have a coding style ..

BTW, you patch had no signed off by ..

Daniel

