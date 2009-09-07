Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbZIGKG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbZIGKG5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 06:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbZIGKG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 06:06:56 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:49485 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbZIGKGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 06:06:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pD/JF2z//BCvAGrlTDJ4l8cN5iUCV7tOllIJvd+JBBUa0DgUBRW7nqsM73MXe9RGwg
         TkZq4V/ZBnxrYXwRw5xJEVzcndYlgacPofbBfaLjIMLIqtoFKxFs92CljBthLvYuxhFE
         Kc5B4msKKlXDcFD+9aACGo+OLJbuF7/TNl/Bo=
Message-ID: <4AA4DB42.1000800@gmail.com>
Date: Mon, 07 Sep 2009 12:06:58 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-8.4 Thunderbird/3.0b3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Nigel Cunningham <ncunningham@crca.org.au>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@lists.tuxonice.net>
Subject: Re: What to do?
References: <4A8CCF95.9030401@crca.org.au> <200908240004.16769.rjw@sisk.pl> <4A91CBB9.1080702@crca.org.au> <200908240120.30776.rjw@sisk.pl>
In-Reply-To: <200908240120.30776.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again.

On 08/24/2009 01:20 AM, Rafael J. Wysocki wrote:
> On Monday 24 August 2009, Nigel Cunningham wrote:
>> We should start by asking where you're at as far as knowledge of swsusp
>> and TuxOnIce goes. 

Well, I know swsups a bit and don't know about toi much. Still I think
it's not a problem at all. I learn quickly ;).

>> I know you've been around the TuxOnIce lists a bit,
>> but don't know how much you know about C programming or the inards of
>> the kernel, swsusp or TuxOnIce (ie how much help do you need to get up
>> to speed?).

I think C is no problem at all, so the kernel. The two I mentioned
above. I think I'll need no or low help from your side regarding the
code site. From what I've read already I would say it's well documented.

> Well, if you start from something that people don't like, it may be difficult
> to push the rest.
> 
> Still, I think Jiri is more than capable of handling that, so more or less
> everything that is a clear improvement and doesn't introduce regressions of any
> kind will probably work for me.

Thank you guys. I needed to cope with other things (a suspend
regression, writable /proc/<pid>/limits etc.) which took me a long time,
sorry.

Then I also went through the last "discussion" around the last merge try
mainly to see what others think about kernel-side implementation of
compression etc.

I hope I'll come up with something early.

Thanks.
