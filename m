Return-Path: <linux-kernel-owner+w=401wt.eu-S1759321AbYEYT6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321AbYEYT6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756566AbYEYT6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:58:04 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:52257 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756491AbYEYT6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:58:03 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -v4] x86: enable preemption in delay
Date: Sun, 25 May 2008 22:58:10 +0300
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200805252108.25011.mitov@issp.bas.bg> <Pine.LNX.4.58.0805251528560.25580@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0805251528560.25580@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805252258.10584.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 May 2008 10:30:25 pm Steven Rostedt wrote:
> 
> On Sun, 25 May 2008, Marin Mitov wrote:
> 
> > Hi Steven,
> >
> > look at this patch, proposed by me and Ingo few month ago.
> > I think it solves the problem you had fond, but unfortunately
> > it had been lost (not included in the mainline).
> >
> > http://lkml.org/lkml/2007/11/20/343
> >
> > It is against the kernel at the moment the message was sent.
> > I think it could be applied to the current kernel too.
> >
> 
> Hi Marin,
> 
> That patch looks basically like what I did. But mine has less code and is

How much "less code" :-)

> a bit simpler ;-)

:-)

Marin Mitov

> 
> Thanks,
> 
> -- Steve
> 


