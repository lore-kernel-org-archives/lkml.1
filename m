Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbYFAJD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbYFAJD6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 05:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbYFAJDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 05:03:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035AbYFAJDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 05:03:49 -0400
Date: Sun, 1 Jun 2008 01:57:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, jeremy@goop.org, mingo@elte.hu,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 0/10] Add generic helpers for arch IPI function calls #4
Message-Id: <20080601015708.917e11c9.akpm@linux-foundation.org>
In-Reply-To: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 10:58:14 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> Jeremy sent me a ping about this patchset, so here's an updated
> version against the current kernel (2.6.26-rc4'ish).

If we're having 2.6.27 thoughts about this work then we should get it
into linux-next pretty soon, please.
