Return-Path: <linux-kernel-owner+w=401wt.eu-S932970AbYEGIdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970AbYEGIdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 04:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbYEGIcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 04:32:50 -0400
Received: from smtp.nokia.com ([192.100.105.134]:32211 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbYEGIcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 04:32:47 -0400
Message-ID: <48216920.1020301@nokia.com>
Date: Wed, 07 May 2008 11:32:32 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [PATCH take 2] UBIFS - new flash file system
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com> <20080507080153.GB23621@infradead.org> <48216353.3020202@nokia.com> <20080507081001.GA14614@infradead.org>
In-Reply-To: <20080507081001.GA14614@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 07 May 2008 08:32:41.0039 (UTC) FILETIME=[E9EF0DF0:01C8B01C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
>> Will git tree work?
>> http://www.linux-mtd.infradead.org/doc/ubifs.html#L_source
> 
> A git tree of just ubifs would be perfect, but the full tree does it
> aswell.  Not really conveniant, but much better than split patches :)

So as it is said at the above URL,
git://git.infradead.org/~dedekind/ubifs-2.6.git is the current
development tree. At the moment it is current Linus's tree + UBIFS.

git-diff a15306365a16380f3bafee9e181ba01231d4acd7 would give UBIFS patch.

git://git.infradead.org/~dedekind/ubifs-v2.6.25.git has v2.6.25 + UBIFS.

I guess this should be ok.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
