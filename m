Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbZDZDtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbZDZDtF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 23:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZDZDsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 23:48:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:57959 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbZDZDsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 23:48:53 -0400
Message-ID: <49F3D9E0.3010100@kernel.org>
Date: Sun, 26 Apr 2009 12:49:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: unsik Kim <donari75@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mg_disk: use defines from <linux/ata.h>
References: <200904251510.03924.bzolnier@gmail.com>
In-Reply-To: <200904251510.03924.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 26 Apr 2009 03:48:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> While at it:
> - remove MG_REG_HEAD_MUST_BE_ON define
> - remove MG_REG_CTRL_INTR_ENABLE define
> - remove MG_REG_HEAD_LBA_MODE define
> - remove unused defines
> 
> Cc: unsik Kim <donari75@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Generally looks good to me.  unsik, what do you think?

Thanks.

-- 
tejun
