Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbYFQSXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbYFQSXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 14:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbYFQSXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 14:23:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51933 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbYFQSXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 14:23:46 -0400
Message-ID: <48580113.9070806@zytor.com>
Date: Tue, 17 Jun 2008 11:23:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Glauber Costa <glommer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: merge setup_memory_map with e820
References: <200806161303.31997.yhlu.kernel@gmail.com>	 <200806161958.28627.yhlu.kernel@gmail.com>	 <5d6222a80806170531g50a72ea2r963bba8e404e619f@mail.gmail.com>	 <4857E07F.3070209@zytor.com>	 <86802c440806170918l1cb10014nccfd8d3e2b13da47@mail.gmail.com>	 <4857F6B5.4000404@zytor.com> <86802c440806171052n6221d13dnf172928b0321dc6a@mail.gmail.com>
In-Reply-To: <86802c440806171052n6221d13dnf172928b0321dc6a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> OK, after Ingo put three patch in the tip, I will submit one to remove
> early_panic.
> 

I'll do it after lunch if Ingo or Thomas don't beat me to it.

	-hpa
