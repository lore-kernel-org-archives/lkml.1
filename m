Return-Path: <linux-kernel-owner+w=401wt.eu-S1751482AbXA3Ed4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbXA3Ed4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 23:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbXA3Ed4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 23:33:56 -0500
Received: from dvhart.com ([64.146.134.43]:42186 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbXA3Edz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 23:33:55 -0500
Message-ID: <45BECA8C.2020405@mbligh.org>
Date: Mon, 29 Jan 2007 20:33:16 -0800
From: "Martin J. Bligh" <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Bug report : reproducible memory bug (hardware failure, sorry)
References: <20070128200917.GA16571@Krystal> <45BD06AC.1080008@mbligh.org> <20070130032734.GA28701@Krystal>
In-Reply-To: <20070130032734.GA28701@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I finally re-ran memtest86 on the machine since it began to have too
> many different kind of errors (GPF, invalid instruction...). It turned
> out that one of the memory modules was bad. I guess my brand new 
> list_debug race condition debugger will be useful in the future, but not
> now. :)
> 
> I'll remember to let memtest86 run a few hours more on my new machines
> next time.

Heh, well that's a lot less confusing at least ;-)

M.
