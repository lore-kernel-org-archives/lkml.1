Return-Path: <linux-kernel-owner+w=401wt.eu-S934187AbXCVSyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934187AbXCVSyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 14:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934189AbXCVSyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 14:54:17 -0400
Received: from science.horizon.com ([192.35.100.1]:14125 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934187AbXCVSyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 14:54:17 -0400
Date: 22 Mar 2007 14:54:13 -0400
Message-ID: <20070322185413.13929.qmail@science.horizon.com>
From: linux@horizon.com
To: jens.axboe@oracle.com, linux@horizon.com
Subject: Re: 2.6.20.3 AMD64 oops in CFQ code
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
In-Reply-To: <20070322184155.GY19922@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 3 (I think) seperate instances of this, each involving raid5. Is your
> array degraded or fully operational?

Ding! A drive fell out the other day, which is why the problems only
appeared recently.

md5 : active raid5 sdf4[5] sdd4[3] sdc4[2] sdb4[1] sda4[0]
      1719155200 blocks level 5, 64k chunk, algorithm 2 [6/5] [UUUU_U]
      bitmap: 149/164 pages [596KB], 1024KB chunk

H'm... this means that my alarm scripts aren't working.  Well, that's
good to know.  The drive is being re-integrated now.
