Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbXDQIqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbXDQIqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 04:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXDQIqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 04:46:04 -0400
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:4949 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752869AbXDQIqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 04:46:01 -0400
Date: Tue, 17 Apr 2007 10:45:58 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Hans de Goede <j.w.r.degoede@hhs.nl>,
       David Hubbard <david.c.hubbard@gmail.com>,
       Rudolf Marek <r.marek@assembler.cz>, Juerg Haefliger <juergh@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [lm-sensors] Hardware monitoring subsystem maintainer position
 is open
Message-ID: <20070417104558.0ff9a230@hyperion.delvare>
In-Reply-To: <20070415150320.GA3158@jupiter.solarsys.private>
References: <20070410150227.1bac05b5@hyperion.delvare>
	<20070415150320.GA3158@jupiter.solarsys.private>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, 15 Apr 2007 11:03:20 -0400, Mark M. Hoffman wrote:
> Hi Jean, et al:
> 
> * Jean Delvare <khali@linux-fr.org> [2007-04-10 15:02:27 +0200]:
> > I am resigning from my role as hardware monitoring subsystem
> > (drivers/hwmon) maintainer. This is too much work for me, I do not have
> > the necessary bandwidth to review all the incoming patches, in
> > particular new drivers, in a timely manner. Patch authors have been
> > complaining about this repeatedly. This is no fun for them, and even
> > less for me, so I'd rather let someone else with more spare time take
> > care of it. If there are volunteers, this is the right time to speak up.
> > 
> > I will still be maintaining the individual hardware monitoring drivers
> > I am listed for in file MAINTAINERS (adm1025, f71805f, lm83 and lm90)
> > as well as the I2C subsystem. No change here.
> > 
> > I will continue to feed -mm with pending hwmon patches until 2.6.21
> > final is released, then I'll send everything I have to Linus for
> > 2.6.22-rc1, the last of which will be:
> >  (...)
> 
> /me throws hat in
> 
> I volunteer to become the new MAINTAINER, but in a much more limited sense
> of the term than Jean is/was.  I can take care of a couple git trees, and do
> some detailed reviews when I have time.  For the most part, I will have to
> rely on others to do reviews as well.

This is excellent news, thanks for volunteering. We have been working
together for a long time now and I'm happy to see you take the lead.
You have my blessing.

> I would not be volunteering for this role, if Juerg and others had not also
> volunteered to be more active reviewers.
> 
> As for the discussions later in this thread about process... IMHO that's a
> little premature.  I intend to get brand new stuff into -mm perhaps a little
> earlier than Jean did... but it still ain't going to Linus before it's ready.
> Other than that, I would rather just see what works for me and for you (other
> hwmon authors).
> 
> Assuming no one else wants the job (ruik?) I'll start working with Jean to
> get things set up as soon as I can.

Great. I'll help you make the transition as smooth as possible.

-- 
Jean Delvare
