Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbXE2MXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbXE2MXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 08:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbXE2MXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 08:23:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:42336 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbXE2MXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 08:23:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=nmocZ1Il6hp8B6zVELh8A/RVYAGgbfrSFm6jlbRDPdFbZut0On4jifq7DEQuM9pgO1uqxaCvpRJkVNnyN3BGnBOOkrGA/rHYHQ6c1Xhs7KTf3jL1aIFHU2GvWqKpwrIYE4ePwKquj9bm+VEPJd33x+VBbSqhRRViyJItDm031Rc=
Message-ID: <465C1AF9.7040605@gmail.com>
Date: Tue, 29 May 2007 14:22:17 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Update Documentation/block/barrier.txt
References: <Pine.LNX.4.62.0705291107250.7698@pademelon.sonytel.be>
In-Reply-To: <Pine.LNX.4.62.0705291107250.7698@pademelon.sonytel.be>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> Documentation/block/barrier.txt is not in sync with the actual code:
>   - blk_queue_ordered() no longer has a gfp_mask parameter
>   - blk_queue_ordered_locked() no longer exists
>   - sd_prepare_flush() looks slightly different
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Acked-by: Tejun Heo <htejun@gmail.com>

Thanks.

-- 
tejun
