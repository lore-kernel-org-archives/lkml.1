Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbZI2MhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbZI2MhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 08:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbZI2MhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 08:37:22 -0400
Received: from smtp.nokia.com ([192.100.122.230]:21125 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbZI2MhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 08:37:21 -0400
Message-ID: <4AC1FE67.7070001@gmail.com>
Date: Tue, 29 Sep 2009 15:32:39 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@nokia.com>,
       Alex Elder <aelder@sgi.com>, Artem Bityutskiy <dedekind@infradead.org>,
       Christoph Hellwig <hch@lst.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jgarzik@redhat.com>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Matt Mackall <mpm@selenic.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Neil Brown <neilb@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       xfs-masters@oss.sgi.com, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 8/9] fs/ubifs: Use %pUX to print UUIDs
References: <cover.1254193019.git.joe@perches.com> <5cf449befe715a79ad0bfaf41ad74f65892134f5.1254193019.git.joe@perches.com>
In-Reply-To: <5cf449befe715a79ad0bfaf41ad74f65892134f5.1254193019.git.joe@perches.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 Sep 2009 12:36:26.0337 (UTC) FILETIME=[75F6ED10:01CA4101]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2009 08:01 AM, Joe Perches wrote:
> Signed-off-by: Joe Perches<joe@perches.com>
> ---
>   fs/ubifs/debug.c |    9 ++-------
>   fs/ubifs/super.c |    7 +------
>   2 files changed, 3 insertions(+), 13 deletions(-)

Looks OK,

Acked-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
