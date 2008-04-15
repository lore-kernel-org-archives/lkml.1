Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbYDOGm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbYDOGm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 02:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYDOGmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 02:42:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244AbYDOGms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 02:42:48 -0400
Date: Mon, 14 Apr 2008 23:42:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] UML: Clean up arch/um/drivers/ubd_kern.c
Message-Id: <20080414234237.48ac4609.akpm@linux-foundation.org>
In-Reply-To: <20080413.005559.143852921.xiyou.wangcong@gmail.com>
References: <20080413.005559.143852921.xiyou.wangcong@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 00:55:59 +0800 (CST) WANG Cong <xiyou.wangcong@gmail.com> wrote:

> Make some global functions and variables static.
> 
> And remove some useless declarations for local functions, since we just
> need to move their definitions ahead.

omg, when checkpatch bit into this patch my CPU melted.

ho hum.
