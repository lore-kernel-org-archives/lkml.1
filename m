Return-Path: <linux-kernel-owner+w=401wt.eu-S936138AbYEVKN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936138AbYEVKN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 06:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759857AbYEVKNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 06:13:17 -0400
Received: from gw.goop.org ([64.81.55.164]:42898 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758404AbYEVKNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 06:13:16 -0400
Message-ID: <4835471D.3090000@goop.org>
Date: Thu, 22 May 2008 11:12:45 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: extend e820 ealy_res support 32bit - fix
References: <200805110030.15510.yhlu.kernel@gmail.com> <200805180118.57863.yhlu.kernel@gmail.com> <200805211840.18619.yhlu.kernel@gmail.com>
In-Reply-To: <200805211840.18619.yhlu.kernel@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> use find_e820_area to find addess for new RAMDISK, instead of using ram blindly
>   

Unfortunately this patch does not resolve the problem for me either.

    J
