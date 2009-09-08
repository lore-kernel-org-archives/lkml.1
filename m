Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbZIHLcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbZIHLcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 07:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbZIHLcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 07:32:18 -0400
Received: from smtp.nokia.com ([192.100.105.134]:34125 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbZIHLcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 07:32:17 -0400
Message-ID: <4AA64097.9030208@gmail.com>
Date: Tue, 08 Sep 2009 14:31:35 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 1/8] writeback: get rid of generic_sync_sb_inodes() export
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com> <1252401791-22463-2-git-send-email-jens.axboe@oracle.com> <4AA631AA.6000803@gmail.com> <20090908104111.GS18599@kernel.dk> <1252407150.5060.51.camel@localhost> <20090908105728.GU18599@kernel.dk> <4AA63992.7040200@gmail.com> <20090908110536.GV18599@kernel.dk>
In-Reply-To: <20090908110536.GV18599@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Sep 2009 11:31:46.0674 (UTC) FILETIME=[F2D49520:01CA3077]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2009 02:05 PM, Jens Axboe wrote:
> Just don't worry about it, things are fine as-is. When the conflict
> happens with the mainline tree, fix it up. If it was a more involved
> depdency chain, we could do something more about it. But for this, I'd
> say it's a lot more work to attempt to "fix" something that is a 10s
> merge issue at pull time.

All right, I'll do this, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
