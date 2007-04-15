Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbXDORyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbXDORyi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 13:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbXDORyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 13:54:37 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:24236 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbXDORya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 13:54:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JUQs5CGDKGC2kBeG1Aa3wzF648eC5gzwGHb1CQCKbhpdFB3RtIf9htMr5EWrLIR7FLQyYJ/gWuq2kguYcDlZfCecdG9tkUBoeiy24AUVE/iXjY45x5q/aaWE9nuArqxGGyLKDNJCAJEGg80wPKj0e3IOK6/C+BBEPe6tl6V55cg=
Message-ID: <191fb4ca0704151054n17b1b423i3df50c292a0cb1cf@mail.gmail.com>
Date: Sun, 15 Apr 2007 10:54:29 -0700
From: "Juerg Haefliger" <juergh@gmail.com>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Subject: Re: [lm-sensors] Hardware monitoring subsystem maintainer position is open
Cc: "Jean Delvare" <khali@linux-fr.org>,
       "LM Sensors" <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Hans de Goede" <j.w.r.degoede@hhs.nl>,
       "David Hubbard" <david.c.hubbard@gmail.com>,
       "Rudolf Marek" <r.marek@assembler.cz>,
       "Krzysztof Helt" <krzysztof.h1@wp.pl>
In-Reply-To: <20070415150320.GA3158@jupiter.solarsys.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070410150227.1bac05b5@hyperion.delvare>
	 <20070415150320.GA3158@jupiter.solarsys.private>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,


On 4/15/07, Mark M. Hoffman <mhoffman@lightlink.com> wrote:
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
>
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

Thanks a lot Mark! I'm sure everybody appreciates very much that you
volunteer for this position.

...juerg


> Thanks & regards,
>
> --
> Mark M. Hoffman
> mhoffman@lightlink.com
>
>
