Return-Path: <linux-kernel-owner+w=401wt.eu-S932803AbYBMJm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbYBMJm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 04:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756265AbYBMJmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 04:42:50 -0500
Received: from smtp.nokia.com ([192.100.122.233]:59197 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249AbYBMJms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 04:42:48 -0500
Message-ID: <47B2BB50.90703@nokia.com>
Date: Wed, 13 Feb 2008 11:41:36 +0200
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: dedekind@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT-PULL] UBI updates
References: <1202809289.3127.9.camel@sauron>
In-Reply-To: <1202809289.3127.9.camel@sauron>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Feb 2008 09:42:21.0221 (UTC) FILETIME=[BAD13550:01C86E24]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> Linus, please pull from
> 
> git://git.infradead.org/~dedekind/ubi-2.6.git master
> 
> to receive few UBI updates and fixes.
> 
> Artem Bityutskiy (2):
>       Documentation: add UBI sysfs ABI docs
>       UBI: be verbose when debuggin is enabled
> 
> S.Çağlar Onur (1):
>       UBI: silence warning
> 
>  Documentation/ABI/stable/sysfs-class-ubi |  212 ++++++++++++++++++++++++++++++
>  drivers/mtd/ubi/debug.h                  |    2 +
>  drivers/mtd/ubi/io.c                     |    4 +
>  drivers/mtd/ubi/vmt.c                    |    4 +-
>  4 files changed, 221 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/ABI/stable/sysfs-class-ubi

Hi Linus,

was I too late with this request or you'd pull later?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
