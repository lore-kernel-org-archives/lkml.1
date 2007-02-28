Return-Path: <linux-kernel-owner+w=401wt.eu-S932414AbXB1OeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbXB1OeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 09:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932872AbXB1OeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 09:34:16 -0500
Received: from az33egw01.freescale.net ([192.88.158.102]:64777 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbXB1OeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 09:34:15 -0500
Message-ID: <45E592DC.9060700@freescale.com>
Date: Wed, 28 Feb 2007 08:34:04 -0600
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1.2pre) Gecko/20070111 SeaMonkey/1.1
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>, Torben.Mathiasen@hp.com
CC: linux-kernel@vger.kernel.org
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
References: <45E46976.6060600@freescale.com> <29c13109971547687159078eacdea008@kernel.crashing.org>
In-Reply-To: <29c13109971547687159078eacdea008@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool wrote:
>>           46 = /dev/ttyCPM0        PPC CPM (SCC or SMC) - port 0
>>              ...
>> -         47 = /dev/ttyCPM5        PPC CPM (SCC or SMC) - port 5
>> +         49 = /dev/ttyCPM5        PPC CPM (SCC or SMC) - port 5
> 
> If CPM0 is 46, then CPM5 is not 47, but not 49 either.
> Unless it's not CPM5 but CPM3?

Honestly, I don't know.  I was just correcting the obvious typo (47 
instead of 49).

I'll try to get an answer from someone, but I'm no CPM expert.

