Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbZJETnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbZJETnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 15:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbZJETnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 15:43:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48573 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbZJETnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 15:43:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 15/21] kernel/power/: use pr_<level> and add pr_fmt(fmt)
Date: Mon, 5 Oct 2009 21:43:37 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc2-rjw; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>, linux-pm@lists.linux-foundation.org
References: <cover.1254701151.git.joe@perches.com> <17906d40d7b002380e893d49639ba3f1e7bdb3a0.1254701151.git.joe@perches.com>
In-Reply-To: <17906d40d7b002380e893d49639ba3f1e7bdb3a0.1254701151.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200910052143.37985.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 October 2009, Joe Perches wrote:
> Added #define pr_fmt(fmt) "PM: " fmt
> Converted printk(KERN_<level> to pr_<level>(
> Removed "PM: " prefix
> Added pr_fmt() to __initdata strings

Well, can you please tell me what actually is wrong with the current code?

Rafael


> Signed-off-by: Joe Perches <joe@perches.com>
> ---
