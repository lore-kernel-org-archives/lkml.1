Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab0BWT6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 14:58:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55809 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab0BWT6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 14:58:03 -0500
Date: Tue, 23 Feb 2010 19:57:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, roland@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de, hjl.tools@gmail.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: linux-next requirements (Was: Re: [tip:x86/ptrace] ptrace: Add
 support for generic PTRACE_GETREGSET/PTRACE_SETREGSET)
Message-ID: <20100223195744.GK30031@ZenIV.linux.org.uk>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
 <tip-2225a122ae26d542bdce523d9d87a4a7ba10e07b@git.kernel.org>
 <20100222090710.GA31357@elte.hu>
 <20100222203319.8bd497a2.sfr@canb.auug.org.au>
 <20100222102745.GJ20844@elte.hu>
 <20100222224752.0cbd5807.sfr@canb.auug.org.au>
 <20100223084552.GB17617@elte.hu>
 <20100223195214.GJ30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100223195214.GJ30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 07:52:14PM +0000, Al Viro wrote:
> On Tue, Feb 23, 2010 at 09:45:52AM +0100, Ingo Molnar wrote:
> 
> > The solution? Stop this anti-real-world-usage bias already. Stop pretending 
> > that those cross-build results are as important as say the thousands of real 
> > bugzilla entries we have. They are fine info, but the kind of priority you are 
> > giving them is causing a waste of resources.
> 
> Ho-hum...  "Kernel won't build for several thousand boxen"...  "Five lines
> contain trailing whitespace"...  Yup, the latter is far higher priority,
> all right.

IOW, I'd buy that argument from somebody who didn't protect checkpatch.pl
wankers against exactly that kind of criticism.
