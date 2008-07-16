Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbYGPE60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbYGPE60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 00:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYGPE6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 00:58:18 -0400
Received: from usmail2.us.checkpoint.com ([216.200.240.146]:46063 "EHLO
	us.checkpoint.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751289AbYGPE6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 00:58:17 -0400
X-Greylist: delayed 2587 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2008 00:58:17 EDT
From: "Rodrigo Rubira Branco" <rbranco@la.checkpoint.com>
To: <linux-kernel@vger.kernel.org>, <stable@kernel.org>
Cc: <greg@kroah.com>, "'Justin Forbes'" <jmforbes@linuxtx.org>,
       "'Zwane Mwaikambo'" <zwane@arm.linux.org.uk>,
       "'Theodore Ts'o'" <tytso@mit.edu>,
       "'Randy Dunlap'" <rdunlap@xenotime.net>,
       "'Dave Jones'" <davej@redhat.com>,
       "'Chuck Wolber'" <chuckw@quantumlinux.com>,
       "'Chris Wedgwood'" <reviews@ml.cw.f00f.org>,
       "'Michael Krufky'" <mkrufky@linuxtv.org>,
       "'Chuck Ebbert'" <cebbert@redhat.com>,
       "'Domenico Andreoli'" <cavokz@gmail.com>, "'Willy Tarreau'" <w@1wt.eu>,
       <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
       <alan@lxorguk.ukuu.org.uk>, "'Alan Cox'" <alan@redhat.com>,
       <caglar@pardus.org.tr>, "'Greg KH'" <gregkh@suse.de>,
       <casey@schaufler-ca.com>
References: <20080701151057.930340322@mini.kroah.org> <200807021257.47593.caglar@pardus.org.tr> <20080702144149.GA16850@suse.de> <200807021809.07679.caglar@pardus.org.tr>
Subject: Re: [stable] Linux 2.6.25.10 (resume)
Date: Wed, 16 Jul 2008 01:01:24 -0300
Message-ID: <005001c8e6f8$ac0955f0$a6181fac@ad.checkpoint.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
In-Reply-To: <200807021809.07679.caglar@pardus.org.tr>
Thread-Index: AcjcVYykqTF/NdeiRx+CPu6Sm7vNGwKock5A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of all sorry for copy many people who maybe are not in the initial
discussion, but since I've not been copied I have no idea who are and who
are not in that thread ;)

The point that many people are trying to make is that Linux has a policy
defined in a document (Documentation/SecurityBugs) but are not following it.

Don't really matter to us what the policy is, but it's really important to
follow it (many people, who are security professionals need that, and many
others, who are NOT security professionals also).

We all know (both sides) that it's impossible to know everything related to
every bug and it's security impact.  But there is a lot of different
situations well-known as a security problems (because the bug class is well
know, because someone reported it with details to the devels, etc).  Hide it
is an option, disclouse it is another.  Have a policy is what matters.  Say
something and do another thing is always bad to everybody involved.
 

P.S:  I'm talking by myself, not for the company that I work for.


Rodrigo Rubira Branco (BSDaemon).

