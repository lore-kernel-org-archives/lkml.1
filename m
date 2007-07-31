Return-Path: <linux-kernel-owner+w=401wt.eu-S1764915AbXGaPJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764915AbXGaPJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761305AbXGaPJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:09:07 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:45364 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762004AbXGaPJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:09:06 -0400
Message-ID: <46AF4FFE.5080202@gmail.com>
Date: Tue, 31 Jul 2007 17:06:38 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: "<::.. Teresa_II ..::>" <teresa@kvitka.net>
CC: CK Mailinglist <ck@vds.kolivas.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
References: <1185827130.26459.16.camel@xtower.fri>
In-Reply-To: <1185827130.26459.16.camel@xtower.fri>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2007 10:25 PM, <::.. Teresa_II ..::> wrote:

> first of all i am not sure if its scheduler issue. But i didn't found
> anything about that in google related to something else.
> 
> So i tried 2.6.22.1 kernel with new cfs scheduler v19.1 from Ingo page.
> Previous i used 2.6.22-ck1.
> 
> After 24 hours running i get strange behavior in Xorg. It act slower
> with my special keys, like SHIFT, or CTRL. So if i hold SHIFT and press
> ")" and than will press enter, i release SHIIFT and press ENTER it
> doesn't create new line. Even if i start write a Sentence or word with
> "SHIFTed" char it makes next char in high case also. 
> Like this: "HAllo" even if i type "Hallo".

For a few days now I have been experiencing a "stuck delete" key while 
reading mail -- I run through the mail with "delete" and every once in a 
while it just keeps on deleting messages while I've already released the 
delete key and was trying to read the next message.

Regular unpatched 2.6.22.1 though and I've recently changed too many things 
to be certain of anything. My X is the modular X.org 1.3.0 since not long, 
and the mailer showing the problem is Thunderbird 2.0.0.5, recently switched 
from 1.5.0.12. The problem was on my "I'll get to it" list but seems this 
could be a good thread to report it into. PS/2 keyboard...

> It's extremely unusable.
> 
> It doesn't happen if i am on other kernel.

Very very sure?

> I am ready to provide any requested information to find issue. If its not
> kernel related thing - i am very sorry, i just don't know where to start
> to trace whats wrong.
> 
> I am on gentoo and use latest xorg server. Keyboard driver is "KBD". 
> Mouse use "evdev" driver.

Rene.


