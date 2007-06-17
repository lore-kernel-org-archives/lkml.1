Return-Path: <linux-kernel-owner+w=401wt.eu-S1760446AbXFQOYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760446AbXFQOYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 10:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759842AbXFQOYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 10:24:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:34180 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760234AbXFQOYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 10:24:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=MabSpTmqHVUmsXQwTuGS1IJ9uNz6I1TzZCkPJYPdPPP6Nr5ZBzOtWeJtqngmNRfAKnz/+hz3CW6lAd8L0wtrCdHDnS4jM0BQXosYESFg+QCYhPeH5ikhQYmes7G9vC/ErWa9+xMYtjkaoflVEZ5yAHGr3ZD237qkH3MLaMVtnTY=
Message-ID: <467543EF.6080605@googlemail.com>
Date: Sun, 17 Jun 2007 16:23:43 +0200
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rodney Gordon II <meff@spherevision.org>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       Mark Fortescue <mark@mtfhpc.demon.co.uk>,
       William Lee Irwin III <wli@holomorphy.com>, Andi Kleen <ak@suse.de>,
       discuss@x86-64.org, Ioan Ionita <opslynx@gmail.com>
Subject: Re: [2/2] 2.6.22-rc5: known regressions
References: <46754153.6040404@googlemail.com>
In-Reply-To: <46754153.6040404@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc5.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



SATA/PATA

Subject    : libata IT821X driver still fails! Hard-freezes system
References : http://lkml.org/lkml/2007/6/14/82
Submitter  : Rodney Gordon II <meff@spherevision.org>
Status     : unknown



Sparc64

Subject    : random invalid instruction occourances on sparc32 (sun4c)
References : http://lkml.org/lkml/2007/6/17/111
Submitter  : Mark Fortescue <mark@mtfhpc.demon.co.uk>
Status     : problem is being debugged

Subject    : 2.6.22-rc broke X on Ultra5
References : http://lkml.org/lkml/2007/5/22/78
Submitter  : Mikael Pettersson <mikpe@it.uu.se>
Handled-By : David Miller <davem@davemloft.net>
Status     : problem is being debugged



x86-64

Subject    : x86-64 2.6.22-rc2 random segfaults
References : http://lkml.org/lkml/2007/5/24/275
Submitter  : Ioan Ionita <opslynx@gmail.com>
Status     : Unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
