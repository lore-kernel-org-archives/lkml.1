Return-Path: <linux-kernel-owner+w=401wt.eu-S966074AbXBOQ1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966074AbXBOQ1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966073AbXBOQ1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:27:44 -0500
Received: from smtp.nokia.com ([131.228.20.170]:24920 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966074AbXBOQ1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:27:43 -0500
Message-ID: <45D489ED.2020202@yandex.ru>
Date: Thu, 15 Feb 2007 18:27:25 +0200
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm1
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 15 Feb 2007 16:26:55.0542 (UTC) FILETIME=[1B7D6560:01C7511E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> - The UBI tree got dropped due to probable lack of a git sync with
>   mainline (ie: it's a 13.5MB diff whcih doesn't apply very well)

Andrew, I apologize for this. Now it is fixed. It somehow got screwed 
when I re-based it from mtd-2.6.git to linu-2.6.git. Please, do not drop it.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
