Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424AbZIHLCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbZIHLCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 07:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbZIHLCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 07:02:07 -0400
Received: from smtp.nokia.com ([192.100.105.134]:30830 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbZIHLCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 07:02:05 -0400
Message-ID: <4AA63992.7040200@gmail.com>
Date: Tue, 08 Sep 2009 14:01:38 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 1/8] writeback: get rid of generic_sync_sb_inodes() export
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com> <1252401791-22463-2-git-send-email-jens.axboe@oracle.com> <4AA631AA.6000803@gmail.com> <20090908104111.GS18599@kernel.dk> <1252407150.5060.51.camel@localhost> <20090908105728.GU18599@kernel.dk>
In-Reply-To: <20090908105728.GU18599@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Sep 2009 11:01:48.0677 (UTC) FILETIME=[C3240350:01CA3073]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2009 01:57 PM, Jens Axboe wrote:
>> But well, if you do not want to carry my patch, then I'll have to
>> re-base my tree later, fix stuff, and send a pull request. I mean,
>> your stuff will for sure be merged first, because I send pull requests
>> late, just because UBIFS is a minor thing in the kernel.
>
> You don't have to rebase, if my work is merged first then you just merge
> Linus' tree into yours and fixup the conflict before asking Linus to
> pull.

I thought Linus asked to avoid merge commits in pull requests at some
point, no? So I thought that I'd re-base then, which Linus also
dislikes :-)

> It's a trivial conflict, I don't understand what the fuzz is about.

Well, I was just thinking how to avoid merge commits. But I guess I can
do what you suggest.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
