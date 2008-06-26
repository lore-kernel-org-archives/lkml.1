Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbYFZSXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbYFZSXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756855AbYFZSWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:22:46 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:53220 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbYFZSWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:22:45 -0400
X-BigFish: VPS-4(zz98dR62a3L7efVzz10d3izzz32i6bh87il43j)
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K331PG-01-807-01
Date: Thu, 26 Jun 2008 20:22:35 +0200
From: Robert Richter <robert.richter@amd.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: rename setup.c to setup_percpu.c
Message-ID: <20080626182235.GF1620@erda.amd.com>
References: <200806251037.11391.yhlu.kernel@gmail.com> <20080626170918.GE1620@erda.amd.com> <86802c440806261107t6d2d1d66r4222017d9da29fbc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <86802c440806261107t6d2d1d66r4222017d9da29fbc@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 26 Jun 2008 18:22:35.0511 (UTC) FILETIME=[9B566070:01C8D7B9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.06.08 11:07:15, Yinghai Lu wrote:
> we want to keep track of setup_32.c

I have seen your patch series afterwards. You are moving back some
parts of the code. I assume setup_percpu.c will only contain per-cpu
code in the end?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

