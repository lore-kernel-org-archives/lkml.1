Return-Path: <linux-kernel-owner+w=401wt.eu-S1752174AbYIAW1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbYIAW1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 18:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbYIAW1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 18:27:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55025 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbYIAW1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 18:27:10 -0400
Date: Mon, 1 Sep 2008 18:24:39 -0400 (EDT)
From: Alan Cox <alan@redhat.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Message-ID: <503446464.5113091220307879885.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
In-Reply-To: <200809011833.02570.bzolnier@gmail.com>
Subject: Re: linux-next: Tree for August 29
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.11.255.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Still happens with next-20080901, also upon closer look it is not
> just an innocent trace dump as /proc/sys/kernel/pty/ dir and its
> content are gone.

That would not surprise me. The 0901 tree would have been built at the end of the weekend. I don't actually work 7 days a week, but 5.

I've pushed that (including a new implementation of the needed field) tonight.

Alan
