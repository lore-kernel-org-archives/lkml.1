Return-Path: <linux-kernel-owner+w=401wt.eu-S1759009AbXGLG7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009AbXGLG7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 02:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbXGLG67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 02:58:59 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:42117 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbXGLG66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 02:58:58 -0400
Date: Thu, 12 Jul 2007 08:56:53 +0200
From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linux RT Users <linux-rt-users@vger.kernel.org>,
       Darren Hart <dvhltc@us.ibm.com>, john stultz <johnstul@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@ext.bull.net>
Subject: Re: [Patch RT] Fix CFS load balancing for RT tasks
Message-ID: <20070712085653.0bb0064d@frecb000686.frec.bull.fr>
In-Reply-To: <Pine.LNX.4.58.0707111341190.18766@gandalf.stny.rr.com>
References: <20070711164708.48907792@frecb000686.frec.bull.fr>
	<1184173580.12353.105.camel@chaos>
	<Pine.LNX.4.58.0707111341190.18766@gandalf.stny.rr.com>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 12/07/2007 09:03:21,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 12/07/2007 09:03:22,
	Serialize complete at 12/07/2007 09:03:22
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 13:41:55 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:

> > On Wed, 2007-07-11 at 16:47 +0200, Sébastien Dugué wrote:
> > >
> > >   P.S. Thanks to Steven Rostedt for logdev which is proving invaluable in
> > >        cases like this.
> > >
> 
> Great to hear!!!
> 
> I'll be uploading a new version of Logdev in a week or so.
> 
> Thanks for the feedback.
> 
> -- Steve
> 

  Great! It's quite a nice and lightweight tool which I think will become
one of my top tools for kernel debugging.

  Just one suggestion, maybe, would be to add to the readme file the
order in which the patches should apply along with a short description
of what functionality they provide (or maybe document the patches and add a
series file).

  Anyway, thanks for that great tool.

  Sébastien.
