Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbYBUCY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbYBUCY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 21:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbYBUCYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 21:24:16 -0500
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:60200 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbYBUCYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 21:24:16 -0500
Message-Id: <6.0.0.20.2.20080221111433.0394f1c8@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Thu, 21 Feb 2008 11:23:20 +0900
To: Jeff Moyer <jmoyer@redhat.com>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [RESEND] [PATCH] fix invalidate_inode_pages2_range not to
  clear ret
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <x49mypv4i2d.fsf@segfault.boston.devel.redhat.com>
References: <6.0.0.20.2.20080215132604.06091618@172.19.0.2>
 <x49mypv4i2d.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff.

>
>I agree with the patch (and I see Andrew already accepted it).  Do you
>have a reproducer for this problem?

Do you want to know the way of failing invalidate_complete_page2() ?

