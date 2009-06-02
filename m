Return-Path: <linux-kernel-owner+w=401wt.eu-S1752533AbZFBWL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbZFBWL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZFBWLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:11:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbZFBWLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:11:20 -0400
Date: Tue, 2 Jun 2009 15:11:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gerard Lledo <gerard.lledo@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, gerard.lledo@gmail.com
Subject: Re: [PATCH] [JFFS2] jffs2_start_garbage_collect_thread() return
 value cleanup
Message-Id: <20090602151112.376ca436.akpm@linux-foundation.org>
In-Reply-To: <1243944686-7039-2-git-send-email-gerard.lledo@gmail.com>
References: <20090602113216.GA3513@tank>
	<1243944686-7039-1-git-send-email-gerard.lledo@gmail.com>
	<1243944686-7039-2-git-send-email-gerard.lledo@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Jun 2009 15:11:26 +0300
Gerard Lledo <gerard.lledo@gmail.com> wrote:

> There is no user of this return value in the kernel.  Change it to return void
> instead.

Both these patches were missing your signed-off-by:.  As your first
version of the first patch wasn't missing it, I added it to both these
patches, OK?

