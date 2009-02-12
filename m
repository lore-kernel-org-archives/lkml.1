Return-Path: <linux-kernel-owner+w=401wt.eu-S1761294AbZBLXvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761294AbZBLXvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 18:51:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZBLXvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 18:51:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37533 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbZBLXvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 18:51:36 -0500
Date: Thu, 12 Feb 2009 18:51:34 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Geoff Levand <geoffrey.levand@am.sony.com>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7][RFC] function graph tracer port to PowerPC
In-Reply-To: <4994B466.5050102@am.sony.com>
Message-ID: <alpine.DEB.1.10.0902121851250.15469@gandalf.stny.rr.com>
References: <20090212011051.265346435@goodmis.org> <4994B1A3.8080502@am.sony.com> <alpine.DEB.1.10.0902121840590.15469@gandalf.stny.rr.com> <4994B466.5050102@am.sony.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 12 Feb 2009, Geoff Levand wrote:

> On 02/12/2009 03:41 PM, Steven Rostedt wrote:
> > On Thu, 12 Feb 2009, Geoff Levand wrote:
> > 
> >> On 02/11/2009 05:10 PM, Steven Rostedt wrote:
> >> > This is the port to PowerPC of the function graph tracer that was written
> >> > by Frederic Weisbecker for the x86 architecture.  It is broken up
> >> > into a series of logical steps.
> >> 
> >> I added these to my ps3-linux.git tree.  Very casual testing shows
> >> they seem to work OK.
> >> 
> >> 
> >> Tested-by: Geoff Levand <geoffrey.levand@am.sony.com>  Working OK on PS3.
> > 
> > Thanks!
> > 
> > Is the ps3 64 or 32 bit? I'll put your tested by on the appropriate 
> > patches.
> 
> It uses the Cell processor, which is 64 bit.

Thanks guys!

-- Steve

