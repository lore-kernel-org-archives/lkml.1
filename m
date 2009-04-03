Return-Path: <linux-kernel-owner+w=401wt.eu-S932094AbZDCLaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094AbZDCLaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762213AbZDCLaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:30:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49277 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760375AbZDCLaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:30:13 -0400
Date: Fri, 3 Apr 2009 13:32:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Avi Kivity <avi@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jim Keniston <jkenisto@us.ibm.com>,
       kvm@vger.kernel.org, systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 0/6 V4] tracing: kprobe-based event tracer
Message-ID: <20090403113203.GB11935@one.firstfloor.org>
References: <49D4F4B5.9040107@redhat.com> <20090403112639.GC31399@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403112639.GC31399@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm wondering about something i suggested many moons ago: to look 
> into the KVM decoder+emulator (arch/x86/kvm/x86_emulate.c).

Hi Ingo,
Me and Masami just discussed this a few emails ago in this thread:)

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
