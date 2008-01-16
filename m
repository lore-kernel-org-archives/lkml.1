Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbYAPUKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbYAPUKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 15:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYAPUKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 15:10:10 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:24668 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbYAPUKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 15:10:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sTaxZ4DFnFOGrtiIbmcBmmrfcWpaOAIjDFGuLpcIGKM3AlmFgMNDPqQ/3hGYNHAGB2UJjZeNyQa6eMHbbDH6gdo4Ye7LgaudyR+fv6wQjA7XSEtqJ93iO9oST0Sl+K4PiNlKufbmX/GfqZDbaT3nLBhyQICK8ABku76IPuGcoIU=
Message-ID: <5bdc1c8b0801161210t63071f40n9521f5530590d309@mail.gmail.com>
Date: Wed, 16 Jan 2008 12:10:06 -0800
From: "Mark Knecht" <markknecht@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: 2.6.24-rc7-rt3
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <Pine.LNX.4.58.0801161453100.15850@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1200456773.318.14.camel@localhost.localdomain>
	 <5bdc1c8b0801161144x62aa3f9bj868602db94b42570@mail.gmail.com>
	 <Pine.LNX.4.58.0801161453100.15850@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 16, 2008 11:55 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 16 Jan 2008, Mark Knecht wrote:
> >
> > Jan 16 11:12:55 lightning sshd[5915]: Server listening on :: port 22.
> > Jan 16 11:12:55 lightning sshd[5915]: error: Bind to port 22 on
> > 0.0.0.0 failed: Address already in use.
> >
> > Will continue testing as I get time.
>
> Thanks,
>
> Are you sure you don't see this when booting the vanilla kernel. Also, if
> you do try a vanilla kernel, don't use the distro version. Use what ever
> version of the -rt patch you used. ie. for 2.6.23-rt1 try out 2.6.23 with
> the same config (with necessary updates).
>
> -- Steve

Steve,
   I'll give it a try. I am pretty sure it's a distro specific issue
so I'm going to check with them about how to properly configure sshd.
It's likely jsut some oversight in one of my config files. Being a
Gentoo user we have more things like this that we have to look after.
Probably some update clobbered something and I just noticed it
recently.

   If I get a quick minute I'll build the 2.6.23 and take a look at that also.

Thanks,
Mark
