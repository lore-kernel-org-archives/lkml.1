Return-Path: <linux-kernel-owner+w=401wt.eu-S1765968AbYETMp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765968AbYETMp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 08:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbYETMpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 08:45:50 -0400
Received: from smtp.nokia.com ([192.100.122.233]:51196 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYETMpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 08:45:49 -0400
Message-ID: <4832C7FF.2090904@yandex.ru>
Date: Tue, 20 May 2008 15:45:51 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH take 2 01/28] VFS: introduce writeback_inodes_sb()
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com>	<1210070159-22794-2-git-send-email-Artem.Bityutskiy@nokia.com>	<20080507002345.831bc379.akpm@linux-foundation.org>	<48218F21.4090304@yandex.ru> <20080507083835.6ba126e6.akpm@linux-foundation.org>
In-Reply-To: <20080507083835.6ba126e6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 20 May 2008 12:45:24.0899 (UTC) FILETIME=[5FAB3730:01C8BA77]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Andrew Morton wrote:
> I already added gti-ubifs.patch to the -mm lineup.  I haven't yet tried
> pulling, merging or compiling it.

is it OK for you if ubifs-2.6.git will have some patches which ubi-2.6.git
also contains. Will your -mm system handle this?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
