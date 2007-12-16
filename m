Return-Path: <linux-kernel-owner+w=401wt.eu-S1763773AbXLPJLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763773AbXLPJLJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 04:11:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbXLPJK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 04:10:57 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42142 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756031AbXLPJKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 04:10:55 -0500
Date: Sun, 16 Dec 2007 01:10:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1
Message-Id: <20071216011050.235ad38a.akpm@linux-foundation.org>
In-Reply-To: <20071215192024.GA2419@martell.zuzino.mipt.ru>
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
	<20071215192024.GA2419@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Dec 2007 22:20:24 +0300 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> FWIW, I got the following at reboot after some tests were finished:
> 
> get_unused_fd: slot 3 not NULL!
> get_unised_fd: slot 4 not NULL!
> general protection fault: 0000 [1] PREEMPT SMP
> last sysfs file /sys/class/scsh_host/host1/link_power_management_policy
> 
> and that's all.

Beats me - nobody has been fiddling with that code for a while.  Worrisome.

