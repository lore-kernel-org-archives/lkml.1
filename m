Return-Path: <linux-kernel-owner+w=401wt.eu-S1761018AbXH3ObR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761018AbXH3ObR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758850AbXH3ObE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:31:04 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:5906 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbXH3ObD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:31:03 -0400
Date: Thu, 30 Aug 2007 08:29:19 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] Override 80-wire cable detection for Toshiba S1800-814
In-reply-to: <fa.xZcOyxsTcgfWflTXq8DY8M1ncqc@ifi.uio.no>
To: Al Boldi <a1426z@gawab.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       dex@dragonslave.de
Message-id: <46D6D43F.8040803@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.aDOpPGIWVD3AP0+s8JbykPNWRao@ifi.uio.no>
 <fa.f0bdB2EM6R3BhlpkdSTPMRlJu9U@ifi.uio.no>
 <fa.xZcOyxsTcgfWflTXq8DY8M1ncqc@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> Alan Cox wrote:
>>> Wow!  I have been running 80wire cable detection override on 40wire
>>> cables for quite some time without any problem, but I never thought it
>>> to be legal if the 40wire cable length is short enough.
>> Yes.
>>
>>> How short does it have to be, and can't we have a kernel bootparm to
>>> override the cable detection?
>> For most users the goal should be to automate behaviour. It should just
>> work.
> 
> What's the max length of a 40wire cable to sustain 80wire cable 
> characteristics?

This is normally only the case on a laptop, where the cable is 
essentially just a tiny stub between the motherboard and the drive. I 
suspect this is something that the system manufacturer has to validate 
works properly, more than any hard and fast limit.

For a normal desktop PC, it would be far better to just use an 80-wire 
cable.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

