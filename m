Return-Path: <linux-kernel-owner+w=401wt.eu-S933176AbXDZG7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176AbXDZG7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933185AbXDZG7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:59:23 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933176AbXDZG7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:59:22 -0400
Date: Wed, 25 Apr 2007 23:58:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Pratt <slpratt@austin.ibm.com>,
       Ram Pai <linuxram@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] on-demand readahead
Message-Id: <20070425235857.7aa81a9b.akpm@linux-foundation.org>
In-Reply-To: <377517042.01728@ustc.edu.cn>
References: <377506695.54393@ustc.edu.cn>
	<p73odlc34ga.fsf@bingen.suse.de>
	<377517042.01728@ustc.edu.cn>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 00:04:00 +0800 Fengguang Wu <fengguang.wu@gmail.com> wrote:

> If this new algorithm has been further tested and approved, I'll
> re-submit the patch in a cleaner, standalone form. The adaptive
> readahead patches can be dropped then. They may better be reworked as
> a kernel module.

that would be appreciated - I just don't know how to move the current patches
forward, and they do get in the way quite regularly.
