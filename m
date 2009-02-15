Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZBOMGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZBOMGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 07:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbZBOMF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 07:05:57 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:31667 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752540AbZBOMF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 07:05:56 -0500
Message-ID: <4998051B.4030904@ru.mvista.com>
Date: Sun, 15 Feb 2009 15:05:47 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Hugh Dickins <hugh@veritas.com>,
       Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #12609] v2.6.29-rc2 libata sff 32bit PIO regression
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.kkF.Ds0lJB@chimera> <499797FD.5070701@lwfinger.net> <4997CDDC.1020103@garzik.org>
In-Reply-To: <4997CDDC.1020103@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Jeff Garzik wrote:

>>> This message has been generated automatically as a part of a report
>>> of recent regressions.
>>>
>>> The following bug entry is on the current list of known regressions
>>> from 2.6.28.  Please verify if it still should be listed and let me 
>>> know
>>> (either way).
>>>
>>>
>>> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=12609
>>> Subject        : v2.6.29-rc2 libata sff 32bit PIO regression
>>> Submitter    : Larry Finger <Larry.Finger@lwfinger.net>
>>> Date        : 2009-01-23 23:52 (23 days old)
>>> References    : http://marc.info/?l=linux-kernel&m=123275478111406&w=4
>>>           http://marc.info/?l=linux-kernel&m=123254501314058&w=4
>>> Handled-By    : Mikael Pettersson <mikpe@it.uu.se>
>>>           Hugh Dickins <hugh@veritas.com>
>>>           Sergei Shtylyov <sshtylyov@ru.mvista.com>
>>> Patch        : http://marc.info/?l=linux-kernel&m=123412278730735&w=4
>>
>> This problem is not fixed as of 2.6.29-rc5.
>
> Sergei, what is the latest version of your patch?   According to my 
> notes, you and Hugh were going back and forth trading patches, and I 
> never saw a final version...

   I've been excessively busy again. Will post today.

>     Jeff

WBR, Sergei


