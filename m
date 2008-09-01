Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbYIAQSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbYIAQSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbYIAQSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:18:01 -0400
Received: from il.qumranet.com ([212.179.150.194]:56061 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbYIAQSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:18:00 -0400
Message-ID: <48BC15B6.6030506@qumranet.com>
Date: Mon, 01 Sep 2008 19:17:58 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched_clock: fix NOHZ interaction
References: <48BABC19.1060509@qumranet.com> <1220281088.8426.63.camel@twins>
In-Reply-To: <1220281088.8426.63.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Avi, the below fixes it for me..
>   

For me too.  Thanks!

-- 
error compiling committee.c: too many arguments to function

