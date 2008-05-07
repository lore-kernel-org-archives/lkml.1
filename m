Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbYEGMCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbYEGMCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 08:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbYEGMCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 08:02:34 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49868 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbYEGMCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 08:02:33 -0400
Message-ID: <48219A2F.7090503@yandex.ru>
Date: Wed, 07 May 2008 15:01:51 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Edward Shishkin <edward.shishkin@gmail.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH take 2 01/28] VFS: introduce writeback_inodes_sb()
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com>      <1210070159-22794-2-git-send-email-Artem.Bityutskiy@nokia.com> <20080507002345.831bc379.akpm@linux-foundation.org> <48218F21.4090304@yandex.ru>
In-Reply-To: <48218F21.4090304@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 07 May 2008 12:02:02.0441 (UTC) FILETIME=[291CE390:01C8B03A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> As Christoph suggested, I've attached a patch which just moves the
> spinlock. Could you please consider sending it to Linus or taking into 
> your tree?

Note, I have tested this patch and it works fine.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
