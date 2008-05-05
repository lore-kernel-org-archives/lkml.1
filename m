Return-Path: <linux-kernel-owner+w=401wt.eu-S1762010AbYEEVDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762010AbYEEVDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757232AbYEEVDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:03:33 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:50159 "EHLO
	zrtps0kp.us.nortel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756275AbYEEVDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:03:33 -0400
Message-ID: <481F7613.6040809@nortel.com>
Date: Mon, 05 May 2008 15:03:15 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Kevin Burton <burton@tailrank.com>, FD Cami <francois.cami@free.fr>,
       linux-kernel@vger.kernel.org
Subject: Re: Ability to limit or disable page caching?
References: <30c6373b0805050012o505c0540i116a31bc1ab9ce9f@mail.gmail.com> <20080505131607.5556b1f2@olorin> <30c6373b0805051134m634efbbdn45167c1eae29df4a@mail.gmail.com> <20080505212831.22371732@olorin> <30c6373b0805051242o2f38f0a3v62bd43f4fa01559e@mail.gmail.com> <20080505164446.2ec9a543@cuia.bos.redhat.com>
In-Reply-To: <20080505164446.2ec9a543@cuia.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 May 2008 21:03:19.0740 (UTC) FILETIME=[7243EFC0:01C8AEF3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On Mon, 5 May 2008 12:42:31 -0700
> "Kevin Burton" <burton@tailrank.com> wrote:

>>What I want to do is either disable the page cache entirely or just
>>tell the OS to cache at max 10% of the available memory.

> I have no such tunable in my code (yet), because I would like the
> kernel to do the right thing automatically.

Given that the kernel doesn't currently do the right thing, what about 
providing a tuneable as a temporary fix for people that are currently 
having problems?

Or are you concerned that they will then not be as willing to test the 
automatic behaviour?

Chris
