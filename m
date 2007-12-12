Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbXLLV1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbXLLV1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbXLLV12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:27:28 -0500
Received: from iriserv.iradimed.com ([72.242.190.170]:30871 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751746AbXLLV12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:27:28 -0500
Message-ID: <47605238.9020402@cfl.rr.com>
Date: Wed, 12 Dec 2007 16:27:20 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Remove all definitions with fastcall
References: <1197491364.21291.14.camel@brick>
In-Reply-To: <1197491364.21291.14.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2007 21:27:37.0205 (UTC) FILETIME=[D115B250:01C83D05]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1023-15602.001
X-TM-AS-Result: No--6.851200-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> fastcall is always defined to be empty, remove it from arch/x86

Why is it always defined to be empty?  Why isn't it used anymore?

