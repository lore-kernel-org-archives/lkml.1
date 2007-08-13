Return-Path: <linux-kernel-owner+w=401wt.eu-S942870AbXHMQvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942870AbXHMQvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938254AbXHMQPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:15:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:6760 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S946557AbXHMQPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:15:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,255,1183359600"; 
   d="scan'208";a="278218270"
Message-ID: <46C0838A.2030504@intel.com>
Date: Mon, 13 Aug 2007 09:15:06 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, joe@perches.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Eng.Linux@digi.com
Subject: Re: [PATCH] [154/2many] MAINTAINERS - DIGI INTL. EPCA DRIVER
References: <46bff988.qGtTTlNorD2He7J3%joe@perches.com> <20070813115344.04759b74@the-village.bc.nu> <46C06E70.9090905@s5r6.in-berlin.de>
In-Reply-To: <46C06E70.9090905@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Aug 2007 16:15:39.0368 (UTC) FILETIME=[3066AE80:01C7DDC5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Alan Cox wrote:
>> On Sun, 12 Aug 2007 23:26:16 -0700
>> joe@perches.com wrote:
>>>  DIGI INTL. EPCA DRIVER
>>> -P:	Digi International, Inc
>>> +P:	Digi International Inc
>> The "," is correct and how they added themselves.
>>
>> Please don't hide other types of change in a large changeset without
>> notice, thats not good
>>
>> NAK
> 
> I'm not Joe, but I gather this change is in order to support generation
> of RFC 278 headers by the proposed script.
> 
> However, rather than mangle entries in MAINTAINERS for the script, I
> suggest that the script is enhanced instead.  Simplest solution:  If the
> script finds punctuation and other problematic characters in the P:
> field, simply omit that part from the e-mail address.

or properly put it on "quotes":

Cc: "Digi International, Inc" <foo@bar.com>

is perfectly valid.


Auke
