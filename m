Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbYEZH6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbYEZH6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 03:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbYEZH6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 03:58:30 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38165 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbYEZH63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 03:58:29 -0400
Message-ID: <483A6D15.6030701@jp.fujitsu.com>
Date: Mon, 26 May 2008 16:56:05 +0900
From: Taku Izumi <izumi.taku@jp.fujitsu.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ACPI: add DMI info to enable OSI(Linux) on PRIMEQUEST
References: <4816F9B9.3090609@jp.fujitsu.com> <4836660B.3080406@jp.fujitsu.com> <483667A4.9000606@jp.fujitsu.com> <20080525114308.GA5237@ucw.cz>
In-Reply-To: <20080525114308.GA5237@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thank you for your response.

>> This patch adds DMI info to enable OSI(Linux) on 
>> PRIMEQUEST.
>> (PRIMEQUEST is ia64 machine.)
> 
> Why is it needed? Why needs your bios know whether it is Linux or BSD
> or whatver running?

   For memory hotplug support.
   Memory hotplug doesn't work on PRIMEQUEST when OSI(Linux) is disabled.

Best regards,
Taku Izumi <izumi.taku@jp.fujitsu.com>

