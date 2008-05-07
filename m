Return-Path: <linux-kernel-owner+w=401wt.eu-S1760622AbYEGBy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622AbYEGBy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbYEGByO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:54:14 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:12093 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbYEGByN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:54:13 -0400
Message-ID: <48210BBE.4050705@googlemail.com>
Date: Wed, 07 May 2008 03:54:06 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at arch/x86/kernel/genapic_64.c:86
References: <c4e36d110804220204h3043e526xee3966876355cde0@mail.gmail.com>	 <200805070041.55369.rjw@sisk.pl> <c4e36d110805061622j7025b4f9ufb4f0d181351e16a@mail.gmail.com>
In-Reply-To: <c4e36d110805061622j7025b4f9ufb4f0d181351e16a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 May 2008 01:47:14.0246 (UTC) FILETIME=[46090660:01C8AFE4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zdenek Kabelac wrote:
> 2008/5/7 Rafael J. Wysocki <rjw@sisk.pl>:
>> On Tuesday, 22 of April 2008, Zdenek Kabelac wrote:
>>  > Hello
>>  >
>>  > I've update to the current commit 2.6.25
>>  > 8a81f2738f10ca817c975cec893aa58497e873b2
>>
>>  Does it still happen with the current -git?
>>
>>
>>
> 
> The last day for this backtrace is from 2nd May in my kernel log.
> So I guess it's been fixed in current git.
> 

Yes this was fixed by Andi Kleen , commit f6c133f7d5ee3b82f5b34b988e897ea38cd8219c

> Zdenek

Gabriel
