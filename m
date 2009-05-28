Return-Path: <linux-kernel-owner+w=401wt.eu-S1763230AbZE1OZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763230AbZE1OZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759669AbZE1OZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:25:42 -0400
Received: from smtp.nokia.com ([192.100.122.230]:33439 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbZE1OZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:25:41 -0400
Message-ID: <4A1E9D8B.8020908@gmail.com>
Date: Thu, 28 May 2009 17:19:55 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com> <4A1E9D0B.4090402@gmail.com>
In-Reply-To: <4A1E9D0B.4090402@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2009 14:20:02.0301 (UTC) FILETIME=[63BEC2D0:01C9DF9F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> question is - should it? 'bdi_register()' a block device,
> but we do not have one.

Sorry, wanted to say: 'bdi_register()' registers a block
device.

Artem.
