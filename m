Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbXLJQrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbXLJQrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 11:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbXLJQrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 11:47:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58152 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbXLJQq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 11:46:59 -0500
Message-ID: <475D6D64.5010006@zytor.com>
Date: Mon, 10 Dec 2007 08:46:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c
References: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org> <20071204032949.c677c021.akpm@linux-foundation.org>
In-Reply-To: <20071204032949.c677c021.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> My ia64 allmodconfig build has taken
> 
> akpm     15700 89.6  0.0   8256   700 pts/4    RN+  03:09  10:41 bc -q kernel/timeconst.bc
> 
> 11 minutes so far.  fc6/x86_64.
> 

Just got back from a week off-net.  Will look into promptly.

That's obviously ridiculous.

	-hpa
