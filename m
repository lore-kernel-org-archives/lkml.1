Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbXHUUiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbXHUUiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbXHUUiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:38:16 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:60894 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbXHUUiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:38:15 -0400
Message-ID: <46CB4C0C.70901@gmail.com>
Date: Tue, 21 Aug 2007 22:33:16 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Geoff Levand <geoffrey.levand@am.sony.com>
CC: Joe Perches <joe@perches.com>, cbe-oss-dev-owner@ozlabs.org,
       Satyam Sharma <satyam@infradead.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       mokuno@sm.sony.co.jp
Subject: Re: [PATCH] PS3: Update MAINTAINERS
References: <20070816211551.11839.patches@notabene>	 <1070816112100.12182@suse.de>	 <Pine.LNX.4.62.0708170910120.8381@pademelon.sonytel.be>	 <alpine.LFD.0.999.0708181953560.29105@enigma.security.iitk.ac.in>	 <Pine.LNX.4.64.0708181628350.5186@fbirervta.pbzchgretzou.qr>	 <alpine.LFD.0.999.0708182016000.29105@enigma.security.iitk.ac.in>	 <Pine.LNX.4.62.0708201313260.6197@pademelon.sonytel.be>	 <alpine.LFD.0.999.0708210523470.2774@enigma.security.iitk.ac.in>	 <Pine.LNX.4.62.0708210904220.11703@pademelon.sonytel.be>	 <alpine.LFD.0.999.0708211500100.2774@enigma.security.iitk.ac.in>	 <Pine.LNX.4.62.0708211148040.6982@pademelon.sonytel.be>	 <alpine.LFD.0.999.0708211605320.2774@enigma.security.iitk.ac.in>	 <46CB3679.3070403@am.sony.com> <1187726479.5963.118.camel@localhost> <46CB45D8.9020801@gmail.com> <46CB4862.9020601@am.sony.com>
In-Reply-To: <46CB4862.9020601@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2007 10:17 PM, Geoff Levand wrote:

> Rene Herman wrote:
>> On 08/21/2007 10:01 PM, Joe Perches wrote:

>>> The reason it is being held:
>>>
>>>     Post by non-member to a members-only list
>> That means it's not a subcriber-only list -- the message wasn't rejected, 
>> just subjected to moderation.
>>
> 
> So maybe it would be more precise to have something like this:
> 
> -L:	cbe-oss-dev@ozlabs.org
> +L:	cbe-oss-dev@ozlabs.org	(moderated)

Perhaps. In these spamridden days, mailinglists that don't have the kind of 
(human and other) resources behind them that linux-kernel has basically have 
the choice between drowning in spam, becoming subscriber only or moderate 
non-subscribers and of these, that third option is "best among the bad".

alsa-devel for example also went this route -- the spam levels simply 
weren't tolerable anymore for any subscriber and the list was dying as a 
result. Moderation sucks, but subcriber-only sucks even worse (generally, 
and/but even more so for lists that expect crossposts from linux-kernel) so 
what's a small-time list to do.

Moderation takes some effort so the lists that moderate have made the 
explicit choice to not become subscriber-only. While subscriber-only 
certainly is useful to mention alongside the list address itself, I'm not 
too sure mentioning moderation makes a great deal of sense actually -- if 
all's well, the moderator will simply approve it and you don't have to deal 
with it other than that.

Rene.

