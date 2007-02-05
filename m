Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbXBEHTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbXBEHTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 02:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbXBEHTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 02:19:35 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:38141 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbXBEHTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 02:19:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cEK1QbPKnN0gvfDOyI0hmzb5dk3jJ+3XYHJOdoxoR3plxBvL8Eqsy0CF3MoSam5/4xl3VY2r9OVusogA4VaXXQ3A0INZDQLrLFheEC3wMiFzZSAPr6qE49gME6k/VAKFRusIRGiSERHJAZPY3wAFNq7Z0zzmUAgVXQdIDir1SyA=
Message-ID: <3877989d0702042319x61230492nc0fc1ed0fa3d58a4@mail.gmail.com>
Date: Mon, 5 Feb 2007 15:19:33 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Mike Galbraith" <efault@gmx.de>
Subject: Re: 2.6.19.2 oops after resume from ram (corruption?)
Cc: nigel@nigel.suspend2.net, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1170307834.7087.16.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1170241008.6512.10.camel@Homer.simpson.net>
	 <1170279722.5389.19.camel@nigel.suspend2.net>
	 <1170307834.7087.16.camel@Homer.simpson.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/07, Mike Galbraith <efault@gmx.de> wrote:
> On Thu, 2007-02-01 at 08:42 +1100, Nigel Cunningham wrote:
> > Hi.
> >
> > On Wed, 2007-01-31 at 11:56 +0100, Mike Galbraith wrote:
> > > Greetings,
> > >
> > > I received the below upon first poke of firefox icon after a resume.
> >
> > Are you able to reproduce it reliably? Failing that, could you try
> > enabling some the kernel configuration options that help with debugging
> > memory corruption (slab corruption checking in particular will probably
> > be the most useful thing here).
>
> No, it's a never before seen event.  That said, I have had a couple of
> dead box after resume events with other kernels in the last few months,
> so I may have had corruption of a more deadly variety.  Unfortunately,
> when I'm resuming, my serial console box is almost guaranteed to be off.

if you have dead serial console, or no serial console at all on you
laptop. Probably you can try the alternative of firewire with
http://www.suse.de/~bk/firewire/
Ah,  linux S3 resume is still a problem.
