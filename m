Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbXKSTYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbXKSTYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 14:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbXKSTYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 14:24:18 -0500
Received: from codepoet.org ([166.70.99.138]:33345 "EHLO codepoet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbXKSTYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 14:24:17 -0500
Date: Mon, 19 Nov 2007 12:24:13 -0700
From: Erik Andersen <andersen@codepoet.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch/backport] CFS scheduler, -v24, for v2.6.24-rc3, v2.6.23.8, v2.6.22.13, v2.6.21.7
Message-ID: <20071119192413.GA12956@codepoet.org>
Reply-To: andersen@codepoet.org
Mail-Followup-To: andersen@codepoet.org, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org
References: <20071119151756.GA25446@elte.hu> <20071119181207.GA11900@codepoet.org> <20071119185237.GA10965@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119185237.GA10965@elte.hu>
X-No-Junk-Mail: I do not want to get *any* junk mail.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon Nov 19, 2007 at 07:52:37PM +0100, Ingo Molnar wrote:
> 
> * Erik Andersen <andersen@codepoet.org> wrote:
> 
> > On Mon Nov 19, 2007 at 04:17:56PM +0100, Ingo Molnar wrote:
> > > 
> > > By popular demand, here is release -v24 of the CFS scheduler patch.
> > > 
> > > It is a full backport of the latest & greatest scheduler code to 
> > > v2.6.24-rc3, v2.6.23.8, v2.6.22.13, v2.6.21.7. The patches can be 
> > > downloaded from the usual place:
> > > 
> > >     http://people.redhat.com/mingo/cfs-scheduler/
> > 
> > Doesn't compile with 2.6.21.7:
> 
> does the patch below help?

Yes, compiles and boots with that change,

 -Erik

--
Erik B. Andersen             http://codepoet-consulting.com/
--This message was written using 73% post-consumer electrons--
