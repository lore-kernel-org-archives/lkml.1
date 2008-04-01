Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbYDAJJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbYDAJJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbYDAJJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 05:09:13 -0400
Received: from smtp.nokia.com ([192.100.122.230]:64353 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbYDAJJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 05:09:12 -0400
Message-ID: <47F1FAAF.7030204@nokia.com>
Date: Tue, 01 Apr 2008 12:04:47 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Artem Bityutskiy <dedekind@yandex.ru>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [RFC PATCH 25/26] UBIFS: add debugging stuff
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>	 <1206629746-4298-26-git-send-email-Artem.Bityutskiy@nokia.com>	 <84144f020803311400s1f34420dx153d197f4752c65e@mail.gmail.com>	 <47F1D44A.8010908@yandex.ru> <47F1E534.7050803@cs.helsinki.fi>	 <47F1F33A.1020909@nokia.com> <84144f020804010200k759b342dy7a7da1d7f86e22ec@mail.gmail.com>
In-Reply-To: <84144f020804010200k759b342dy7a7da1d7f86e22ec@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2008 09:08:37.0745 (UTC) FILETIME=[F88F4610:01C893D7]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> But they're totally different kind of thing! They're not for disabling
> hundreds of debug-only printks sprinkled around the kernel. Instead,
> they let you disable well-defined debugging checks for kernel speed
> and/or size optimizations. And btw, CONFIG_SLUB_DEBUG is only a kernel
> size optimization for CONFIG_EMBEDDED. The SLUB debugging code can be
> turned on and off at run-time.

Then I probably misunderstood you, sorry. My English is far from perfect.
Could you please again put your requests together and try to make each
request asking for a small thing. Probably be more specific about each
request (referring the code, saying why exactly this is harmful, etc).
It would just help a lot.

I thought you want us to remove all the UBIFS the debugging altogether.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
