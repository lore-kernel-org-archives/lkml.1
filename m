Return-Path: <linux-kernel-owner+w=401wt.eu-S1752642AbXJWLum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbXJWLum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 07:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbXJWLue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 07:50:34 -0400
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:1789 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751491AbXJWLud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 07:50:33 -0400
Date: Tue, 23 Oct 2007 13:50:30 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Bart Van Assche" <bart.vanassche@gmail.com>, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org
Subject: Re: [PATCH] I2C: add support for the PCF8575 chip
Message-ID: <20071023135030.750e9fa4@hyperion.delvare>
In-Reply-To: <20071022145814.84e46287.akpm@linux-foundation.org>
References: <e2e108260710050232s1b0a9cb7u604ab7e20b61646e@mail.gmail.com>
	<20071022145814.84e46287.akpm@linux-foundation.org>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Mon, 22 Oct 2007 14:58:14 -0700, Andrew Morton wrote:
> On Fri, 5 Oct 2007 11:32:35 +0200
> "Bart Van Assche" <bart.vanassche@gmail.com> wrote:
> 
> > From: Bart Van Assche
> > 
> > Add support for the PCF8575 I2C chip.
> 
> I'll comment on this 17-day-old patch.
> 
> Jean, this illustrates why explicitly steering people *away* from lkml or
> from any other mailing list is a poor idea.  If Bart has posted an updated
> version to the i2c list then I end up reviewing an outdated patch, and
> probably duplicating other people's comments.

You're unfair. I can use the same argument the other way around: if
Bart did not post to the wrong list in the first place, then there
would have been no risk for you to miss any update.

I stand on my initial affirmation that sending all patches, bug reports
etc. to LKML when more specialized lists exist, is a bad idea. Maybe it
makes you happy because you want to know everything that's going on in
every area on the kernel, and are lucky enough to be able to actually
do that and survive. But for others, it's essentially wasting their
time (not to mention bandwidth and disk space.)

If you are so interested about i2c patches, then I'd suggest that you
simply subscribe to the i2c list.

> googling for 'PCF8575 Assche' indicates that he has not sent an updated
> patch.  Perhaps he was discouraged by your quite unconstructive response.

Actually Bart resent his patch to the i2c list 3 days later, twice. But
it was probably the exact same patch (it didn't mention any changes at
least.) There's no reason why Bart would have sent an updated patch as
he did not receive feedback at this point. I fail to see how my
response would have had any influence in that respect.

Anyway, thanks for the review. I didn't have much time left for reviews
these last few weeks.

Still... I am worried that you, Andrew Morton, co-top-maintainer of the
Linux 2.6 kernel, one of most brilliant kernel developers we have,
waste your time doing the initial review of a random i2c patch that
about anyone remotely involved in kernel development would have been
able to review. There's something wrong here.

-- 
Jean Delvare
