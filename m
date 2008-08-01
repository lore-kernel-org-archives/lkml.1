Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYHAEc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYHAEc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 00:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYHAEcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 00:32:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239AbYHAEcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 00:32:52 -0400
Date: Thu, 31 Jul 2008 21:32:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [GIT PATCH] hwmon updates against v2.6.26
Message-Id: <20080731213221.bb3830d6.akpm@linux-foundation.org>
In-Reply-To: <20080801041026.GI3375@mars.solarsys.private>
References: <20080801041026.GI3375@mars.solarsys.private>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008 00:10:27 -0400 "Mark M. Hoffman" <mhoffman@lightlink.com> wrote:

> Hi Linus:
> 
> Please pull from:
> 	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git release

ack.

> You'll get what few patches I've managed to look at in the last few months,
> including a patch to MAINTAINERS which makes it official.  I'm sorry I was
> not able to keep up - I should have admitted defeat much sooner.

Thanks for all the work.  There are many subsystems for which the
maintainer is, err, me.

> To all lm-sensors/hwmon developers: please resend/CC patches to Andrew.

Yup.  I'll subscribe to those lists and shall do the occasional
troll-for-missed-stuff there.

You'll also find that I'll still cc yourself on everything (including
patches) so please do keep an eye out for goofups.

>  MAINTAINERS                 |    6 

 HARDWARE MONITORING
-P:     Mark M. Hoffman
-M:     mhoffman@lightlink.com
 L:     lm-sensors@lm-sensors.org
 W:     http://www.lm-sensors.org/
-T:     git lm-sensors.org:/kernel/mhoffman/hwmon-2.6.git testing
-T:     git lm-sensors.org:/kernel/mhoffman/hwmon-2.6.git release
-S:     Maintained
+S:     Orphaned

