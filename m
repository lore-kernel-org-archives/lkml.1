Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbYHRV6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbYHRV6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYHRV62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:58:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480AbYHRV62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:58:28 -0400
Date: Mon, 18 Aug 2008 14:57:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, vapier.adi@gmail.com, cooloney@kernel.org
Subject: Re: [PATCH 1/4] Blackfin RTC Driver: move irq request/free out of
 open/release and into probe/remove so that the non-dev interfaces (like
 sysfs) work as expected
Message-Id: <20080818145753.24985a74.akpm@linux-foundation.org>
In-Reply-To: <1218790880-12477-2-git-send-email-cooloney@kernel.org>
References: <1218790880-12477-1-git-send-email-cooloney@kernel.org>
	<1218790880-12477-2-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008 17:01:17 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> Subject: [PATCH 1/4] Blackfin RTC Driver: move irq request/free out of open/release and into probe/remove so that the non-dev interfaces (like sysfs) work as expected

umm, please don't try to fit the whole changelog into the patch title.

> Date: Fri, 15 Aug 2008 17:01:17 +0800
> X-Mailer: git-send-email 1.5.6
> 
> From: Mike Frysinger <vapier.adi@gmail.com>

put it here instead?

> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
