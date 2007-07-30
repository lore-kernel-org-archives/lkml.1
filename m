Return-Path: <linux-kernel-owner+w=401wt.eu-S939057AbXG3HGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939057AbXG3HGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 03:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938814AbXG3HGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 03:06:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:39077 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S938727AbXG3HGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 03:06:16 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX188zV9wfWM8XT1RYT8FxTWQ1scu9N9Pl4MWYWFAIj
	k7SzcyHjDmzqsu
Message-ID: <46AD8387.2070706@gmx.net>
Date: Mon, 30 Jul 2007 08:21:59 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: fallocate() man page
References: <20070713123816.GA18000@amitarora.in.ibm.com> <20070713124601.GA22961@amitarora.in.ibm.com> <20070714082342.174830@gmx.net> <20070716053235.GA10945@amitarora.in.ibm.com> <46A44629.3090107@gmx.net> <20070723131039.GA29198@amitarora.in.ibm.com> <20070724070652.GX31489@sgi.com>
In-Reply-To: <20070724070652.GX31489@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



David Chinner wrote:
> On Mon, Jul 23, 2007 at 06:40:39PM +0530, Amit K. Arora wrote:
>> On Mon, Jul 23, 2007 at 08:09:45AM +0200, Michael Kerrisk wrote:
>>> I've taken the page that you sent and made various minor formatting and
>>> wording fixes.  I've also added various FIXMEs to the page.  Some of these
>>> ("FIXME .") are things that I need to check up later.  Some others are
>>> questions for which I need input from you, David, or someone else with the
>>> relevant info (I've marked these "FIXME Amit:").  Could you please review,
>>> and send a new draft of the page back to me.
>> Thanks for going through the manpage and improving it!
>>
>> My comments are below in between <Amit> ... </Amit> tags.
> 
> Does this Q&A really need to be encoded in nroff comments? ;)
> 
>> .\" FIXME Amit: I need author and license information for this page.
>> .\" <Amit>
>> .\"    David Chinner is the original author, hence he can help with this.
>> .\" </Amit>
> 
> Patch below.

Thanks David.  Applied, but I wrote "GNU General Public License vesion 2".

Cheers,

Michael

