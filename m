Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZDVOHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZDVOHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 10:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbZDVOHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 10:07:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36248 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZDVOHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 10:07:06 -0400
Date: Wed, 22 Apr 2009 10:07:04 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/core] tracing/events: make struct trace_entry->type
 to be int type
In-Reply-To: <20090422135221.GB5249@elte.hu>
Message-ID: <alpine.DEB.2.00.0904221006440.24310@gandalf.stny.rr.com>
References: <49EEDB0E.5070207@cn.fujitsu.com> <tip-7a4f453b6d7379a7c380825949977c5a838aa012@git.kernel.org> <alpine.DEB.2.00.0904220924000.24310@gandalf.stny.rr.com> <20090422135221.GB5249@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 22 Apr 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ingo,
> > 
> > We need to make type 2 bytes not 4.
> 
> yeah, saw that - it's OK with 2 bytes too.
> 
> > I sent out a patch to do this change last month
> > 
> >  http://patchwork.kernel.org/patch/14573/
> 
> Mind resending it in your next batch of patches?

OK,

Will do ;-)

-- Steve

