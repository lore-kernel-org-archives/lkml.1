Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbYGKTVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbYGKTVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 15:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759288AbYGKTSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 15:18:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759289AbYGKTSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 15:18:42 -0400
Date: Fri, 11 Jul 2008 12:17:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: aeb@cwi.nl, axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add error handling to add_partition() and callers
Message-Id: <20080711121743.a88065fc.akpm@linux-foundation.org>
In-Reply-To: <20080709175139.15954.79394.stgit@warthog.procyon.org.uk>
References: <20080709175139.15954.79394.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jul 2008 18:51:39 +0100 David Howells <dhowells@redhat.com> wrote:

> Add error handling to add_partition() and its callers.

Please review -mm's

fs-partition-checkc-fix-return-value-warning.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch

and advise whether changes are needed.
