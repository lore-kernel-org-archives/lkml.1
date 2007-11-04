Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbXKDTm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbXKDTm3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 14:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbXKDTmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 14:42:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51400 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbXKDTmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 14:42:17 -0500
Message-ID: <472E2086.20209@zytor.com>
Date: Sun, 04 Nov 2007 11:41:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH] fix i486 boot failure due to stale %ds
References: <200711041938.lA4JcXGk013845@harpo.it.uu.se>
In-Reply-To: <200711041938.lA4JcXGk013845@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> 
> First patch didn't build. Second patch builds and boots Ok.
> 
> So this means the 486 DX4 has a buggy mov to %cr0?
> 

Apparently.

	-hpa
