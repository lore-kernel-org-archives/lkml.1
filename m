Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbYAMErT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbYAMErT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 23:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYAMErK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 23:47:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbYAMErJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 23:47:09 -0500
Date: Sat, 12 Jan 2008 23:46:52 -0500
From: Rik van Riel <riel@redhat.com>
To: Anton Salikhmetov <salikhmetov@gmail.com>
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, ksm@42.dk, staubach@redhat.com,
       jesper.juhl@gmail.com, torvalds@linux-foundation.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org, protasnb@gmail.com
Subject: Re: [PATCH 1/2] massive code cleanup of sys_msync()
Message-ID: <20080112234652.114bd8cd@bree.surriel.com>
In-Reply-To: <12001992013606-git-send-email-salikhmetov@gmail.com>
References: <12001991991217-git-send-email-salikhmetov@gmail.com>
	<12001992013606-git-send-email-salikhmetov@gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jan 2008 07:39:58 +0300
Anton Salikhmetov <salikhmetov@gmail.com> wrote:

> Substantial code cleanup of the sys_msync() function:
> 
> 1) using the PAGE_ALIGN() macro instead of "manual" alignment;
> 2) improved readability of the loop traversing the process memory regions.
> 
> Signed-off-by: Anton Salikhmetov <salikhmetov@gmail.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed.
