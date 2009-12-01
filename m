Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbZLARyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbZLARyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbZLARyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:54:00 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:42523 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbZLARx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:53:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j8GfqNuhboRotkjdEcPk/RNUy6/bWKCvoMYa9io/WeIy7Nr1BE+w748misXu1tB4Cx
         XfsoArC9hAGWIABeToZcCD2kx9swOO2JqSkoam9mAF9ImokjqX1zFUEMgAYn7cVaNk2U
         1wzZvmjQCpRojCJu8wwdDIg0mP24MyDCQs1Ac=
Date: Tue, 1 Dec 2009 18:54:06 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] trace_syscalls: Remove unused
	event_syscall_enter and event_syscall_exit
Message-ID: <20091201175403.GC5080@nowhere>
References: <4B14D278.4090209@cn.fujitsu.com> <tip-bf56a4ea9f1683c5b223fd3a5dbea23f1fa91c34@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-bf56a4ea9f1683c5b223fd3a5dbea23f1fa91c34@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 04:42:35PM +0000, tip-bot for Lai Jiangshan wrote:
> Commit-ID:  bf56a4ea9f1683c5b223fd3a5dbea23f1fa91c34
> Gitweb:     http://git.kernel.org/tip/bf56a4ea9f1683c5b223fd3a5dbea23f1fa91c34
> Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
> AuthorDate: Tue, 1 Dec 2009 16:23:20 +0800
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 1 Dec 2009 17:33:28 +0100
> 
> trace_syscalls: Remove unused event_syscall_enter and event_syscall_exit
> 
> fix event_enter_##sname->event
> fix event_exit_##sname->event
> 
> remove unused event_syscall_enter and event_syscall_exit
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Acked-by: Jason Baron <jbaron@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> LKML-Reference: <4B14D278.4090209@cn.fujitsu.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>


Except for this patch. The whole series is really nice, thanks
a lot for this cleanup!

