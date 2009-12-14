Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888AbZLNF7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbZLNF7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 00:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbZLNF7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 00:59:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752514AbZLNF7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 00:59:17 -0500
Date: Sun, 13 Dec 2009 21:58:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] kfifo: fix warn_unused_result
Message-Id: <20091213215827.20fd4c56.akpm@linux-foundation.org>
In-Reply-To: <1260765399.6620.51.camel@wall-e>
References: <1260523108.27010.7.camel@wall-e>
	<20091213142907.d0ac63da.akpm@linux-foundation.org>
	<1260765399.6620.51.camel@wall-e>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 05:36:39 +0100 Stefani Seibold <stefani@seibold.net> wrote:

> If it is okay, i will remove the __must_check from kfifo_in and
> kfifo_in_locked.

That works, I suppose.

