Return-Path: <linux-kernel-owner+w=401wt.eu-S1030532AbXHMMgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030532AbXHMMgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760829AbXHMHDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:03:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933933AbXHMHDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:03:47 -0400
Date: Mon, 13 Aug 2007 00:04:40 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [490/2many] MAINTAINERS - USB BLOCK DRIVER (UB ub)
Message-Id: <20070813000440.fedfa634.zaitcev@redhat.com>
In-Reply-To: <46bffc48.jq7Ax2MlK/hZ/ANM%joe@perches.com>
References: <46bffc48.jq7Ax2MlK/hZ/ANM%joe@perches.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I received two updates, and something jumped out:

On Sun, 12 Aug 2007 23:38:00 -0700, joe@perches.com wrote:
> +F:	drivers/block/ub.c

On Sun, 12 Aug 2007 23:38:30 -0700, joe@perches.com wrote:
> +F:	/drivers/usb/class/usblp.c

Why do some patterns start with a leading slash and others do not?

-- Pete
