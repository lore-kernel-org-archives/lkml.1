Return-Path: <linux-kernel-owner+w=401wt.eu-S1758880AbYJPXUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbYJPXUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbYJPXUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:20:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755362AbYJPXUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:20:44 -0400
Date: Thu, 16 Oct 2008 16:20:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, rdunlap@xenotime.net
Subject: Re: [Patch] kernel/configs.c: remove useless comments
Message-Id: <20081016162012.ebbb0efb.akpm@linux-foundation.org>
In-Reply-To: <20081016160454.GG13374@hack.voiplan.pt>
References: <20081016160454.GG13374@hack.voiplan.pt>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 17:04:54 +0100
Am__rico Wang <xiyou.wangcong@gmail.com> wrote:

> These comments are useless, remove them.

Thanks for doing this, but...

We have about 10000000000000 useless comments in the kernel.  I
wouldn't want to clean them up with 10000000000000/3 tiny patches.  It
would be more practical if we were to merge larger patches with names like
"remove all useless comments in kernel/*.c".

