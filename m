Return-Path: <linux-kernel-owner+w=401wt.eu-S1765765AbXHMQIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765765AbXHMQIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S947305AbXHMOpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:45:10 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:59111 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S946470AbXHMOpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:45:06 -0400
Message-ID: <46C06E70.9090905@s5r6.in-berlin.de>
Date: Mon, 13 Aug 2007 16:45:04 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: joe@perches.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Eng.Linux@digi.com
Subject: Re: [PATCH] [154/2many] MAINTAINERS - DIGI INTL. EPCA DRIVER
References: <46bff988.qGtTTlNorD2He7J3%joe@perches.com> <20070813115344.04759b74@the-village.bc.nu>
In-Reply-To: <20070813115344.04759b74@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Sun, 12 Aug 2007 23:26:16 -0700
> joe@perches.com wrote:
>>  DIGI INTL. EPCA DRIVER
>> -P:	Digi International, Inc
>> +P:	Digi International Inc
> 
> The "," is correct and how they added themselves.
> 
> Please don't hide other types of change in a large changeset without
> notice, thats not good
> 
> NAK

I'm not Joe, but I gather this change is in order to support generation
of RFC 278 headers by the proposed script.

However, rather than mangle entries in MAINTAINERS for the script, I
suggest that the script is enhanced instead.  Simplest solution:  If the
script finds punctuation and other problematic characters in the P:
field, simply omit that part from the e-mail address.
-- 
Stefan Richter
-=====-=-=== =--- -==-=
http://arcgraph.de/sr/
