Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbYH2XUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbYH2XUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 19:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYH2XUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 19:20:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223AbYH2XUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 19:20:46 -0400
Date: Fri, 29 Aug 2008 16:20:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: joe.korty@ccur.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make might_sleep() display the oopsing process
Message-Id: <20080829162003.8f66cafe.akpm@linux-foundation.org>
In-Reply-To: <20080828093628.GA28783@elte.hu>
References: <20080827152139.GA11460@tsunami.ccur.com>
	<20080828093628.GA28783@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008 11:36:28 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> > Expand might_sleep's printk to indicate the oopsing process.
> 
> good idea

Why?  I don't recall ever having been interested in this information.

(I shouldn't have to ask questions like this.  Please spend a little
more time in preparing the patch descriptions).

