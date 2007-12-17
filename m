Return-Path: <linux-kernel-owner+w=401wt.eu-S1762245AbXLQURZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762245AbXLQURZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936705AbXLQUEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 15:04:04 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935263AbXLQUEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 15:04:00 -0500
Message-ID: <4766D502.9020100@redhat.com>
Date: Mon, 17 Dec 2007 14:58:58 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jcliburn@gmail.com
Subject: Re: [PATCH] drivers/net/: Spelling fixes
References: <1197920439-5455-2-git-send-email-joe@perches.com>
In-Reply-To: <1197920439-5455-2-git-send-email-joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
>  drivers/net/atl1/atl1_hw.c                     |    2 +-
>  drivers/net/atl1/atl1_main.c                   |    2 +-

The atl1 code will be heavily reworked in the 2.6.25 merge window, so this may 
cause headaches.  Please remove these chunks before merging.

The spelling corrections themselves are fine, and I will ensure that the revised 
driver includes them, if the comments in question are still present at all once 
we're done with all the changes and cleanups.

	-- Chris
