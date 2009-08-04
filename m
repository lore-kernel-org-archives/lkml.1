Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbZHDIP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbZHDIP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbZHDIP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:15:26 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:61506 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbZHDIPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:15:25 -0400
Date: Tue, 4 Aug 2009 09:14:56 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Paul Mundt <lethal@linux-sh.org>, Thomas Gelixner <tglx@linuxtronix.de>
Subject: Re: [PATCH 0/2] Resend of ftrace recordmcount.pl fixes
Message-ID: <20090804081456.GB4084@console-pimps.org>
References: <cover.1249365713.git.matt@console-pimps.org> <20090804080602.GA18635@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804080602.GA18635@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 10:06:02AM +0200, Ingo Molnar wrote:
> 
> * Matt Fleming <matt@console-pimps.org> wrote:
> 
> > I'm resending these two patches as they seem to be stalled.
> > 
> > Matt Fleming (2):
> >   ftrace: Fix the conditional that updates $ref_func
> >   ftrace: Only update $offset when we update $ref_func
> > 
> >  scripts/recordmcount.pl |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> Applied to tip:tracing/urgent, thanks Matt!
> 
> 	Ingo

Thank you!
