Return-Path: <linux-kernel-owner+w=401wt.eu-S1757653AbYLDOXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbYLDOXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbYLDOXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:23:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45260 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbYLDOXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:23:10 -0500
Date: Thu, 4 Dec 2008 09:23:07 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/3] ftrace: use struct pid
In-Reply-To: <m11vwoumjn.fsf@frodo.ebiederm.org>
Message-ID: <alpine.DEB.1.10.0812040921410.5240@gandalf.stny.rr.com>
References: <20081204052638.425740534@goodmis.org> <20081204052735.175697908@goodmis.org> <m11vwoumjn.fsf@frodo.ebiederm.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 4 Dec 2008, Eric W. Biederman wrote:

> Steven Rostedt <rostedt@goodmis.org> writes:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> >
> > Impact: clean up
> >
> > Eric Biederman suggested using the struct pid for filtering on
> > pids in the kernel. This patch is based off of a demonstration
> > of an implementation that Eric sent me in an email.
> 
> Please find_get_vpid and pid_vnr.  

I could not find a "find_get_vpid".

-- Steve

