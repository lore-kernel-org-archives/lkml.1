Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbXFAWRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbXFAWRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbXFAWQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:16:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:50101 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbXFAWQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:16:52 -0400
From: Olaf Dietsche <olaf+list.linux-acpi@olafdietsche.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
References: <878xb35sje.fsf@goat.bogus.local> <200706012237.17375.rjw@sisk.pl>
	<87k5un4bwk.fsf@goat.bogus.local> <200706012340.54394.rjw@sisk.pl>
Date: Sat, 02 Jun 2007 00:17:34 +0200
Message-ID: <87hcpr2ubl.fsf@goat.bogus.local>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX1/WWb2PNafO4D3zz7lE3zGsCOAYrtXkhkSzrv8
 h5yxuYfqMYSDvv9S6PfyMI0meBYAl2LLa/6oHmhFBSdVtjZPUO
 h9yet0k00t+oWPPpLicdQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Friday, 1 June 2007 23:12, Olaf Dietsche wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>> > On Friday, 1 June 2007 22:27, Olaf Dietsche wrote:
>> >> When I resume, everything seems to come up (fan becomes busy, disk and
>> >> dvd spin up for a short time),
>> >
>> > Hmm, what about the screen?
>> 
>> When the laptop is dead, screen remains black.
>> 
>> When I skip acpi_enter_sleep_state(), the screen works like everything
>> else.
>
> I think you should try s2ram (http://en.opensuse.org/s2ram) as the first step.

It doesn't work. I tried all options "s2ram -f (-s, -p, -m, -r, -a 1, -a 2,
-a 3)" one after the other.

Since the screen (or any other device) works without problems, when I
skip acpi_enter_sleep_state(), I don't think it's screen related.

Regards, Olaf.
