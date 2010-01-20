Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213Ab0ATRBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab0ATRBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 12:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062Ab0ATRBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 12:01:53 -0500
Received: from mail.windriver.com ([147.11.1.11]:57997 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab0ATRBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 12:01:53 -0500
Message-ID: <4B5736DA.40305@windriver.com>
Date: Wed, 20 Jan 2010 11:01:14 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 20/40] arm,kgdb: Add hook to catch an oops with debugger
References: <20100114174821.GB21385@n2100.arm.linux.org.uk> <4B4F7EC2.6030000@windriver.com> <20100114204647.GE21385@n2100.arm.linux.org.uk> <4B54706C.20202@windriver.com> <20100120160319.GC27507@n2100.arm.linux.org.uk>
In-Reply-To: <20100120160319.GC27507@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jan 2010 17:01:15.0163 (UTC) FILETIME=[2D1F1EB0:01CA99F2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Mon, Jan 18, 2010 at 08:30:04AM -0600, Jason Wessel wrote:
>   
>> That being said, you patch works for the purpose of catching the
>> exception and returning with or without the addition of an earlier
>> return before bust_spinlocks() which I had proposed.
>>     
>
> So does that mean I can have an acked-by for the patch?
>   
Absolutely.

Jason.

Acked-by: Jason Wessel <jason.wessel@windriver.com>
