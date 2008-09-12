Return-Path: <linux-kernel-owner+w=401wt.eu-S1760846AbYILVBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760846AbYILVBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759588AbYILUvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:51:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64904 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759613AbYILUvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:51:44 -0400
Date: Fri, 12 Sep 2008 16:51:40 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Robert Schwebel <robert@schwebel.de>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26.5-rt9
In-Reply-To: <20080912202732.GM9852@pengutronix.de>
Message-ID: <alpine.DEB.1.10.0809121650250.2332@gandalf.stny.rr.com>
References: <1221166441.22713.36.camel@localhost.localdomain> <20080912202732.GM9852@pengutronix.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 12 Sep 2008, Robert Schwebel wrote:

> On Thu, Sep 11, 2008 at 04:54:01PM -0400, Steven Rostedt wrote:
> > We are pleased to announce the 2.6.26.5-rt9 tree, which can be
> > downloaded from the location:
> 
> On the MPC5121e-ADS (Powerpc 32) I get this oops during my boot sequence when
> enabling CONFIG_DYNAMIC_FTRACE. Without that option the oops doesn't happen.

Thanks for the report. Unfortunately, the only PPC32 box I have is my
powerbook, which has never been able to boot a RT kernel :-( But I'll look
to see if the issue is with Linus's tree as well.

Thanks for the report.

-- Steve
