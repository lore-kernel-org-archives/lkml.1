Return-Path: <linux-kernel-owner+w=401wt.eu-S1758494AbYDTTRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494AbYDTTRW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 15:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbYDTTRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 15:17:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33853 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbYDTTRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 15:17:14 -0400
Message-ID: <480B95B4.5030203@zytor.com>
Date: Sun, 20 Apr 2008 15:12:52 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mitch Bradley <wmb@firmworks.com>
CC: Andres Salomon <dilinger@queued.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	<20080419031024.GC3503@nineveh.local>	<20080418202925.b18452c5.akpm@linux-foundation.org>	<20080419092544.378664a8@ephemeral>	<20080419133909.5aa6b63e@ephemeral>	<86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>	<480B321B.5020802@zytor.com> <20080420135948.61bdb4c9@ephemeral> <480B8E9F.8000701@firmworks.com>
In-Reply-To: <480B8E9F.8000701@firmworks.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mitch Bradley wrote:
> 
> The x86 architecture doesn't make this problem easy.
> 

[long rant about the x86 architecture]

It would be more useful if you described the actual defined entry 
conditions from OpenFirmware look like, including if they are 
well-defined for all OF implementations or only for OLPC.

	-hpa
