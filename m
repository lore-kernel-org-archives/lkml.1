Return-Path: <linux-kernel-owner+w=401wt.eu-S1761276AbYEVLB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761276AbYEVLB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 07:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYEVLBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 07:01:19 -0400
Received: from smtp.nokia.com ([192.100.122.233]:55989 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYEVLBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 07:01:19 -0400
Message-ID: <4835524C.8030502@yandex.ru>
Date: Thu, 22 May 2008 14:00:28 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH take 2 01/28] VFS: introduce writeback_inodes_sb()
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com>      <1210070159-22794-2-git-send-email-Artem.Bityutskiy@nokia.com>  <20080507002345.831bc379.akpm@linux-foundation.org>     <48218F21.4090304@yandex.ru>    <20080507083835.6ba126e6.akpm@linux-foundation.org>     <4832C7FF.2090904@yandex.ru> <20080520104907.e77ae05d.akpm@linux-foundation.org> <483550C5.1010100@yandex.ru>
In-Reply-To: <483550C5.1010100@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 May 2008 11:00:29.0940 (UTC) FILETIME=[0C683340:01C8BBFB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> OK. The thing is that we'd like to have UBI patches in UBIFS tree to give
> them a test. So what I've done I've created a branch named "for_andrew".
> Could you please switch your scripts from "master" branch to "for_andrew"
> branch? This branch will have the same but UBI patches which are already
> in the UBI tree and would cause conflicts.

Err, probably I was vague. I was asking to use this for UBIFS:

git://git.infradead.org/~dedekind/ubifs-2.6.git for_andrew

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
