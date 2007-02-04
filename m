Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbXBDN54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbXBDN54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 08:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbXBDN5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 08:57:55 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:46010 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbXBDN5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 08:57:55 -0500
Message-ID: <45C5E66A.1090005@gmail.com>
Date: Sun, 04 Feb 2007 14:58:02 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hwsusp defunct
References: <45C5DBBA.20502@gmail.com> <200702041452.28874.rjw@sisk.pl>
In-Reply-To: <200702041452.28874.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki napsal(a):
> Hi,
> 
> On Sunday, 4 February 2007 14:12, Jiri Slaby wrote:
>> Hi.
>>
>> When I'm trying to suspend to mem one machine, it wakes immediatly back with 
>> nothing notable in dmesg:
> [--snip--] 
>> Will PM_DEBUG or ACPI_DEBUG help somehow? Or later kernel?
> 
> Later kernel might help, some important fixes have gone in since 2.6.19,
> PCI quirks-related etc.
> 
> Please try 2.6.20-rc7 and if that doesn't help, try the latest -mm.

Yes, I'll try it next week (maybe 2.6.20 will be out) and will keep you informed.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
