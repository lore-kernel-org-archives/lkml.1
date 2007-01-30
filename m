Return-Path: <linux-kernel-owner+w=401wt.eu-S965534AbXA3OpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965534AbXA3OpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965532AbXA3OpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:45:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965535AbXA3OpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:45:15 -0500
Message-ID: <45BF59ED.3090203@stud.feec.vutbr.cz>
Date: Tue, 30 Jan 2007 15:45:01 +0100
From: Michal Schmidt <xschmi00@stud.feec.vutbr.cz>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: linux@bohmer.net
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [OOPS] on 2.6.20-rc5-rt10
References: <3efb10970701300630w3c235233ic7613e8f74a7b4f2@mail.gmail.com>
In-Reply-To: <3efb10970701300630w3c235233ic7613e8f74a7b4f2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remy Bohmer wrote:
> Hello All,
> 
> Once in a while we see the following stacktrace.
> We do not know yet the exact condition that generates this, but is
> there anyone that recognises this oops?
> 
> Kind Regards,
> 
> Remy Bohmer
> 
> [...]
> Jan 30 14:09:20 localhost kernel: Modules linked in: cap_over
> commoncap i2c_dev uhci_hcd i2c_i801 i2c_core ehci_hcd

What's the cap_over module? I can't find it in my kernel anywhere.
Michal
