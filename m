Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbXDKJuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbXDKJuP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbXDKJuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:50:15 -0400
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:3834 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751857AbXDKJuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:50:14 -0400
Date: Wed, 11 Apr 2007 11:49:05 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Rudolf Marek <r.marek@assembler.cz>
Subject: Re: Hardware monitoring subsystem maintainer position is open
Message-ID: <20070411114905.3f114375@hyperion.delvare>
In-Reply-To: <461BB006.9020308@hhs.nl>
References: <20070410150227.1bac05b5@hyperion.delvare>
	<461BB006.9020308@hhs.nl>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Tue, 10 Apr 2007 17:40:54 +0200, Hans de Goede wrote:
> Jean Delvare wrote:
> > I am resigning from my role as hardware monitoring subsystem
> > (drivers/hwmon) maintainer. This is too much work for me, I do not have
> > the necessary bandwidth to review all the incoming patches, in
> > particular new drivers, in a timely manner. Patch authors have been
> > complaining about this repeatedly. This is no fun for them, and even
> > less for me, so I'd rather let someone else with more spare time take
> > care of it. If there are volunteers, this is the right time to speak up.
> 
> I'm sorry to hear this and I can't help but think that my, erm, rant* yesterday 
> is somehow involved in you making this decision.

Obviously, it is. But please don't feel responsible for it. This just
happened to be the trigger, but that would have happened anyway.

> This was in no way my intention.

I know.

> My intention was to try and make you change how you handle these things,

Except that this isn't how open-source development works. You're not my
boss, you don't get to tell me how I should work. I work the way I
like, and if it doesn't fit with the rest of the community, I better
move on.

> my intention was to make you less of a perfectionist and to distribute 
> the work more, you cannot do everything yourself. I think that if you could 
> change that you would be able to cope with the load better.

Perfectionist - you said it. This is what I am, and this is unlikely to
change in a near future (if ever). But being a subsystem maintainer
requires that you trust contributors to some degree, and you just can't
trust contributors when you're a perfectionist. This means that the
maintainer should be less of a perfectionist than the contributors,
otherwise he/she ends up doing everything by him/herself.

> I think you're experience / knowledge when it comes to hwmon stuff is very 
> valuable and if you leave / quit doing hwmon stuff this would be a big loose.

I didn't say I would leave entirely. I plan to stay around and keep
helping with the lm-sensors project and hwmon drivers. I just don't
want to be the hwmon subsystem maintainer anymore, as I don't fit in
the role and this makes me (and others) unhappy.

-- 
Jean Delvare
