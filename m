Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYDUPCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYDUPCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 11:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYDUPCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 11:02:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47851 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbYDUPCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 11:02:40 -0400
Message-ID: <480CAB8B.1030009@zytor.com>
Date: Mon, 21 Apr 2008 10:58:19 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: Mitch Bradley <wmb@firmworks.com>, Andres Salomon <dilinger@queued.net>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: OLPC: Add support for calling into Open Firmware
References: <20080419031024.GC3503@nineveh.local> <20080418202925.b18452c5.akpm@linux-foundation.org> <20080419092544.378664a8@ephemeral> <20080419133909.5aa6b63e@ephemeral> <86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com> <480B321B.5020802@zytor.com> <20080420135948.61bdb4c9@ephemeral> <480B8E9F.8000701@firmworks.com> <480B95B4.5030203@zytor.com> <480C0C5B.2050403@firmworks.com> <20080421150546.GB6354@cosmic.amd.com>
In-Reply-To: <20080421150546.GB6354@cosmic.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jordan Crouse wrote:
> 
> This is off topic slightly, but let it be known that the coreboot project
> considers OFW a very valid option for x86 platforms.  A kernel that
> worked happily with OFW would greatly encourage people to adopt it in
> lieu of other BIOS / firmware solutions.
> 
> I return you to your previously scheduled debate.
> 

The interface they are proposing is definitely not suitable for upward 
extension, for the reasons already mentioned.  However, they have units 
in the field, and the amount of changes required to support another 
interface should be relatively minor.

Hence my insistence that we don't promote it as *the* OFW interface, but 
*a* OFW interface.

	-hpa
