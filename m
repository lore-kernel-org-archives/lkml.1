Return-Path: <linux-kernel-owner+w=401wt.eu-S932609AbZHDIIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbZHDIIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932305AbZHDIIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:08:04 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:45729 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773AbZHDIIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:08:01 -0400
Date: Tue, 4 Aug 2009 17:08:01 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Matt Fleming <matt@console-pimps.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -tip] ftrace: Correctly calculate the first function in the .text section
Message-ID: <20090804080801.GA8338@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
	Matt Fleming <matt@console-pimps.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <1248342703-15758-1-git-send-email-matt@console-pimps.org> <alpine.DEB.2.00.0907231043330.20997@gandalf.stny.rr.com> <alpine.DEB.2.00.0907231052010.20997@gandalf.stny.rr.com> <20090727222935.GA22208@linux-sh.org> <alpine.DEB.2.00.0907271941360.30108@gandalf.stny.rr.com> <20090802081602.GB5011@linux-sh.org> <20090804080723.GB18635@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804080723.GB18635@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 10:07:23AM +0200, Ingo Molnar wrote:
> 
> * Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > > Could you push these off to Linus? My git pull request had:
> > > 
> > > Message-ID: <20090723210047.294710482@goodmis.org>
> > 
> > This is still outstanding. Should I just merge it in to my tree 
> > and send it to Linus instead?
> 
> No need, i've picked them up for -rc6.
> 
Great, thanks Ingo!
