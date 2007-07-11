Return-Path: <linux-kernel-owner+w=401wt.eu-S932510AbXGKL4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510AbXGKL4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762762AbXGKL4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:56:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:26876 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762887AbXGKL4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:56:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qsP54mEMM6PDtiveBWgjdHYeoxD+y0KhpCqP/aT+JdmX3sOnSC5V9DoyKmdKewmzr4gsjMJDWgdhy6JLM7F+we4g+SIFHu2/A5ng+4N4YzMHEyid7UvqlUHpNU/CMu6qfMMtdpntnLmMyECQ3tFj/Xa9MT9kaGJ+oeBw9FtR0hQ=
Message-ID: <9a8748490707110456v25b69e1eq5e2f054b4df35cea@mail.gmail.com>
Date: Wed, 11 Jul 2007 13:56:17 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Satyam Sharma" <ssatyam@cse.iitk.ac.in>
Subject: Re: [PATCH v2 -mm 4/9] netconsole: Add some useful tips to documentation
Cc: "Joel Becker" <Joel.Becker@oracle.com>, "Matt Mackall" <mpm@selenic.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Keiichi Kii" <k-keiichi@bx.jp.nec.com>,
       Netdev <netdev@vger.kernel.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0707111120120.10373@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710091920.23907.96483.sendpatchset@cselinux1.cse.iitk.ac.in>
	 <20070710091941.23907.45658.sendpatchset@cselinux1.cse.iitk.ac.in>
	 <20070710094142.GM11115@waste.org>
	 <200707101434.39938.jesper.juhl@gmail.com>
	 <Pine.LNX.4.64.0707110256220.2445@cselinux1.cse.iitk.ac.in>
	 <20070711042036.GR1011@tasint.org>
	 <Pine.LNX.4.64.0707111120120.10373@cselinux1.cse.iitk.ac.in>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/07, Satyam Sharma <ssatyam@cse.iitk.ac.in> wrote:
> On Tue, 10 Jul 2007, Joel Becker wrote:
> > On Wed, Jul 11, 2007 at 03:40:22AM +0530, Satyam Sharma wrote:
> > > IMHO something that mentions /proc/sys/kernel/printk would be better.
> > >
> > > You don't need to have built with SysRq support for that, it's clearly
> > > more flexible than the ignore_loglevel option and wouldn't require a
> > > reboot either. I'll send out an updated patch shortly.
> >
> >       Why not dmesg -n?  We've been using that for years.  Or is there
> > some extra change in /proc/sys/kernel/printk?
>
> Yes, "dmesg -n" sounds the most straightforward. There are multiple ways
> of course, for some reason I've always used /proc/sys/kernel/printk for
> this (which has the extra "feature" that it accepts values greater than
> 8 too :-)
>
Why not mention all the various methods, dmesg -n,
/proc/sys/kernel/printk, SysRq, ignore_loglevel  ??

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
