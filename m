Return-Path: <linux-kernel-owner+w=401wt.eu-S933372AbXGMOWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372AbXGMOWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 10:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758530AbXGMOWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 10:22:12 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:49323 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757772AbXGMOWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 10:22:11 -0400
Message-ID: <46978A71.6030706@gmail.com>
Date: Fri, 13 Jul 2007 16:21:37 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
CC: Tilman Schmidt <tilman@imap.cc>, Satyam Sharma <satyam.sharma@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Gmail and flowed text (was Re: Correction to LZO1X)
References: <a781481a0707110636l3b56a25j174603a5a8af3186@mail.gmail.com>	 <4697402C.9000402@imap.cc> <4d8e3fd30707130242r1ee26618ua6bd20ec82132b8f@mail.gmail.com>
In-Reply-To: <4d8e3fd30707130242r1ee26618ua6bd20ec82132b8f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2007 11:42 AM, Paolo Ciarrocchi wrote:

> On 7/13/07, Tilman Schmidt <tilman@imap.cc> wrote:

>> Get a real E-mail account. :-)
>>
>> Seriously: after years of hassles with freemailers, I finally
>> decided that E-mail is so important for me it's worth spending
>> a small yearly amount. Never regretted the step.
> 
> Sorry for suddently jumping into the discussion, my understanding is
> that all the problems with Gmail are related to the web interface, if
> you don't use it, or you use it only to read messages/sent messages
> (no patches), everything is fine.
> 
> Am I correct?

No, definitely not. Gmail is a lost cause.

For example, I get moderation requests for a mailing lists that include a
copy of the message and gmail's mandatory spamfilter just cannot be taught
that I _do_ want to see those moderation requests, however it may feel about
the included message. I have much better spam-filtering at home, since I can
train it to my personal usage patterns. Can't switch it off though...

As another example, also if you only use the SMTP/POP access, gmail filters
out your own posts to mailing lists, overriding whatever "send back to me"
preference you may have set in the mailing list configuration.

It also does mandatory "duplicate" filtering where a duplicate is defined as
any message that was delivered to you as part of a mailing list, again
overriding personal preferences the user has set in the mailing list
configuration and personally having caused me to miss messages addressed to 
me. Daddy gmail knows best...

If you are emailing to destinations that can be made to let through the SPF
neutral result gmail sends back if you use a different SMTP server (this was
a problem with osdl.org for a short while; I couldn't reach @osdl.org
addresses anymore) and _have_ a different SMTP server that'll allow you to
post with an @gmail.com from address, using gmail as a forwarding-only 
address sort of works.

You'll have to login frequently to the web-interface anyway to go through
its spam folder fishing out all the non-spam and will have to suffer
sometimes getting and sometimes not getting back your own list mail (I
completely lost sight of the logic there) though and I'm close to just
giving up and telling gmail where to stick its mandatory crap.

A simple forwarding address can be had anywhere and most won't keep a, 
privacy sensitive but again mandatory, archive of all mail you received in 
the "Trash" folder until you manually login and empty that as well.

Gmail is all about not letting you make your own choices. Which probably
accounts for its success -- it's a goal shared by the most successful
companies in IT it seems.

Rene.

