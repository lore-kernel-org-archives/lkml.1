Return-Path: <linux-kernel-owner+w=401wt.eu-S1758643AbYAGX3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643AbYAGX3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 18:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758028AbYAGX3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 18:29:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57448 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756967AbYAGX3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 18:29:04 -0500
Date: Mon, 7 Jan 2008 15:28:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       bfennema@falcon.csc.calpoly.edu, jack@suse.cz
Subject: Re: [PATCH] udf: convert some macros to functions
Message-Id: <20080107152815.acab7678.akpm@linux-foundation.org>
In-Reply-To: <20080107204413.GB22144@joi>
References: <1199580275-2487-1-git-send-email-marcin.slusarz@gmail.com>
	<1199580275-2487-6-git-send-email-marcin.slusarz@gmail.com>
	<20080107122617.GB3710@infradead.org>
	<20080107204413.GB22144@joi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008 21:44:26 +0100
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> > There's some overly long lines here and some odd style, this should look
> > more like:
> These long lines were split later in "[PATCH 1/7] udf: fix coding style"

Confused.  How can patch 1/n come "later" than this one?

Your patches actually came through as "[patch] udf: ...".  ie: no
sequence numbering.

> (but I will fix it in next version of this patch).

Please fix the sequence numbering too, thanks.
