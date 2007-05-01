Return-Path: <linux-kernel-owner+w=401wt.eu-S1423697AbXEAVib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423697AbXEAVib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423615AbXEAVib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:38:31 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:42287 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423697AbXEAVia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:38:30 -0400
Message-ID: <4637B2AF.5000509@student.ltu.se>
Date: Tue, 01 May 2007 23:35:43 +0200
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Convert to generic boolean
References: <20070501190607.32350.4822.sendpatchset@thinktank.campus.ltu.se> <20070501212619.46cf36f8@the-village.bc.nu>
In-Reply-To: <20070501212619.46cf36f8@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Tue, 1 May 2007 21:08:36 +0200 (MEST)
> Richard Knutsson <ricknu-0@student.ltu.se> wrote:
>
>   
>> Convert to generic boolean
>>
>> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
>> ---
>> Compile-tested but most arch/conf tested failed for other reasons then this
>> Diffed against Linus' git-tree.
>>     
>
> If you can't build test stuff like ps2esdi then its best to leave it
> alone - we know the old driver code works/worked and in a few years even
> James won't have any working PS/2 hardware left
>   
Just thought the patch is so trivial that it obviously is "correct".

Richard Knutsson

