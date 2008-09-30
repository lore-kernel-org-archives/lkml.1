Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYI3XLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYI3XLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 19:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbYI3XL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 19:11:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49310 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbYI3XL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 19:11:29 -0400
Message-ID: <48E2B20D.5000404@zytor.com>
Date: Tue, 30 Sep 2008 16:11:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: mtrr_cleanup update command line and doc mtrr-cleanup-debug
 v2
References: <1222812370-16188-1-git-send-email-yhlu.kernel@gmail.com>
In-Reply-To: <1222812370-16188-1-git-send-email-yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> change enable_mtrr_cleanup to mtrr-cleanup, disable_mtrr_cleanup to nomtrr-cleanup.
> so doc mtrr-cleanup-debug.
> 
> v2: some _ to -
> 
> and change MTRR_SANITIZER to def_bool y

Could you split that into two patches, please?

	-hpa
