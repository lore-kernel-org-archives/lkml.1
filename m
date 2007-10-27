Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbXJ0RAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbXJ0RAS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 13:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbXJ0RAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 13:00:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:17082 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbXJ0RAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 13:00:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=FwXV0Hqrt/dTJz5vtHX9grlRFri3tw8tX0CLV3bRZoUZfifPUwRxfhRt22leXqODrqc93Y8tY9PkKgkaoMRhb25LkvJUxhB6cstgPuWC14/R7mH98n2tzhs5X3aQQ/uSZY8mA2zlb0ILzhkhbzxjyBPvbXtyQI0jbv1E3kHD3xY=
Message-ID: <47236E79.3060707@gmail.com>
Date: Sat, 27 Oct 2007 20:59:37 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Frans Pop <elendil@planet.nl>
Subject: Re: [2.624-rc1 regression] lost battery information
References: <200710262024.06012.arvidjaar@mail.ru> <200710271855.52866.arvidjaar@mail.ru> <47235727.30808@gmail.com> <200710272049.11969.arvidjaar@mail.ru>
In-Reply-To: <200710272049.11969.arvidjaar@mail.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> On Saturday 27 October 2007, Alexey Starikovskiy wrote:
>> As you wish... :) Please check the attached patch.
>>
> 
> Not sure why you need to reimplement acpi_extract_package, but ...
Take a look on memory allocations around it... :)
> 
> Tested-by: Andrey Borzenkov <arvidjaar@mail.ru>

