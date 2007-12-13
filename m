Return-Path: <linux-kernel-owner+w=401wt.eu-S933064AbXLMVKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbXLMVKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764508AbXLMVJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:09:54 -0500
Received: from iriserv.iradimed.com ([72.242.190.170]:52159 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765154AbXLMVJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:09:53 -0500
Message-ID: <47619F9F.1080502@cfl.rr.com>
Date: Thu, 13 Dec 2007 16:09:51 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Remove all definitions with fastcall
References: <1197491364.21291.14.camel@brick>  <47605238.9020402@cfl.rr.com> <1197495102.21291.28.camel@brick>
In-Reply-To: <1197495102.21291.28.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Dec 2007 21:10:29.0794 (UTC) FILETIME=[971CF820:01C83DCC]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1023-15604.001
X-TM-AS-Result: No--10.487700-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> It was a leftover from before regparm(3) became the default on x86-32.
> 
> It doesn't have any use now.
> 
> Harvey

You mean the default calling convention is now fastcall instead of cdecl 
or stdcall?

