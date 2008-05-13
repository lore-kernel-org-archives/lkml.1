Return-Path: <linux-kernel-owner+w=401wt.eu-S1760004AbYEMJZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004AbYEMJZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 05:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759862AbYEMJZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 05:25:08 -0400
Received: from smtp.nokia.com ([192.100.122.230]:54087 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987AbYEMJZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 05:25:06 -0400
Message-ID: <48295DC2.50009@yandex.ru>
Date: Tue, 13 May 2008 12:22:10 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Edward Shishkin <edward.shishkin@gmail.com>
Subject: Re: [PATCH take 2 01/28] VFS: introduce writeback_inodes_sb()
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com> <1210070159-22794-2-git-send-email-Artem.Bityutskiy@nokia.com> <20080507002345.831bc379.akpm@linux-foundation.org> <20080507080027.GA23621@infradead.org> <482951D0.3070004@yandex.ru> <20080513085959.GA23849@infradead.org>
In-Reply-To: <20080513085959.GA23849@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 May 2008 09:23:49.0044 (UTC) FILETIME=[0D15F740:01C8B4DB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> Sorry, www.infradead.org was down during the weeked when I had some time
> to review it.  I've grabbed a copy of the new tarball now and will look
> at it soon.
Thanks.

> Also I don't think it's too late for .26 as ubifs only adds
> new code except the writeback_inodes_sb bit which should be trivial
> enough for .26.

Thanks. Though it depends on the results of your review and Linus. Let's
see how it all goes.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
