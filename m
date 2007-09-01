Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbXIASmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbXIASmz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 14:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbXIASmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 14:42:47 -0400
Received: from barikada.upol.cz ([158.194.242.200]:42114 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbXIASmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 14:42:46 -0400
X-Greylist: delayed 1108 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Sep 2007 14:42:46 EDT
To: Sam Ravnborg <sam@ravnborg.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Cc: <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: Documentation files in html format?
In-Reply-To: <20070810074047.GC31307@uranus.ravnborg.org>
References: <20070809113122.3aa508e4@oldman.hamilton.local> <200708091508.20626.hjk@linutronix.de> <p73hcn8g25m.fsf@bingen.suse.de> <20070810074047.GC31307@uranus.ravnborg.org>
Date: Sat, 1 Sep 2007 20:39:14 +0200
Message-Id: <E1IRXsI-0008Qt-CF@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Date: Fri, 10 Aug 2007 09:40:47 +0200
* Sam Ravnborg:
>
> Documentation should be easy to access and readable in the source format.
> For this purpose asciidoc seems to do a good job.
>
> It is btw. discussed at git ML if they should shift due to toolset being
> slow but that happens to be the docbook utilities. asciidoc seems to be fast enough.
> And it can produce both HTML and docbook so seems to cover all cases.

just plain text

another option: txt2tags && sed

For me anything else, like man, info, (xml, html)+css, is a brain
damage. If it's fine for you -- it's your wasted time and mood.

(yet another big useless thread on useless OT, how sad).
____
