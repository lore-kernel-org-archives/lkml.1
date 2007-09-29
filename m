Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbXI2KpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbXI2KpU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 06:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbXI2KpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 06:45:08 -0400
Received: from smtp.nokia.com ([131.228.20.171]:30179 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbXI2KpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 06:45:06 -0400
Message-ID: <46FE2CA5.1080606@yandex.ru>
Date: Sat, 29 Sep 2007 13:44:53 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tytso@mit.edu
Subject: Re: Write-back from inside FS - need suggestions
References: <46FCC686.3050009@yandex.ru>        <46FE2167.8000800@yandex.ru> <20070929033939.6ee65e19.akpm@linux-foundation.org>
In-Reply-To: <20070929033939.6ee65e19.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 Sep 2007 10:44:54.0192 (UTC) FILETIME=[C52B6300:01C80285]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> I'd have thought that a suitable wrapper around a suitably-modified
> sync_sb_inodes() would be appropriate for both filesystems?

Hmm, OK, I'll try to do this. Thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
