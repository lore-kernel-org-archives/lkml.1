Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbXKCNeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbXKCNeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 09:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbXKCNeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 09:34:04 -0400
Received: from www17.your-server.de ([213.133.104.17]:52694 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbXKCNeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 09:34:03 -0400
Message-ID: <472C78BE.6020201@m3y3r.de>
Date: Sat, 03 Nov 2007 14:33:50 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] v2.6.24-rc1-497-gb1d08ac: kde battery icon gone
References: <472B5C01.7090508@m3y3r.de> <20071103063520.13EA59AFABF@smtp05.mtu.ru>
In-Reply-To: <20071103063520.13EA59AFABF@smtp05.mtu.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov schrieb:
> Thomas Meyer wrote:
>
>   
>> i just wanted to report this:
>>
>> in v2.6.24-rc1-497-gb1d08ac the kde battery icon is no longer displayed.
>>
>> with 2.6.23 shows the battery icon.
>>
>> current config:
>>
>> grep -i acpi .config
>> # Power management options (ACPI, APM)
>> CONFIG_ACPI=y
>> CONFIG_ACPI_SLEEP=y
>> # CONFIG_ACPI_PROCFS is not set
>>     
>
> And if you enable it (ACPI_PROCFS)?
>   
And there it is again...
