Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbZCFVrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbZCFVrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 16:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbZCFVrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 16:47:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755616AbZCFVrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 16:47:04 -0500
Date: Fri, 6 Mar 2009 13:46:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: unsik Kim <donari75@gmail.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk,
       shdl@zakalwe.fi, harvey.harrison@gmail.com, minchan.kim@gmail.com,
       donari75@gmail.com, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH v2] mflash: Initial support v2
Message-Id: <20090306134645.65172897.akpm@linux-foundation.org>
In-Reply-To: <1236306550-8257-1-git-send-email-donari75@gmail.com>
References: <20090305142746.a2c6f415.akpm@linux-foundation.org>
	<1236306550-8257-1-git-send-email-donari75@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Mar 2009 11:29:10 +0900
unsik Kim <donari75@gmail.com> wrote:

> This is same as <1236245899-6706-1-git-send-email-donari75@gmail.com> titled
> "[PATCH] mflash: reflect akpm's review". Only change change log and title.
> (because old title was not suitable and need more explanation in change log)

OK, that worked, thanks.

I merged both patches into my tree, with the intention of sending them
on to Jens for review and possible integration via the block tree. 
(IOW: ping!!!!).

Please cc jens on future emails regarding this driver, thanks.
