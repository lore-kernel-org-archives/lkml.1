Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbZHXUTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbZHXUTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 16:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbZHXUTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 16:19:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914AbZHXUTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 16:19:16 -0400
Date: Mon, 24 Aug 2009 13:15:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: anders@alarsen.net (Anders Larsen)
Cc: trivial@kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qnx4: remove write support
Message-Id: <20090824131547.a8c268fa.akpm@linux-foundation.org>
In-Reply-To: <20090822135645.C7E43414574@oscar>
References: <20090822135645.C7E43414574@oscar>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Aug 2009 15:56:45 +0200 (CEST)
anders@alarsen.net (Anders Larsen) wrote:

> To: trivial@kernel.org

This isn't a trivial patch!

> Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
> Subject: [PATCH] qnx4: remove write support
> Date: 	Sat, 22 Aug 2009 15:56:45 +0200 (CEST)
> Sender: linux-kernel-owner@vger.kernel.org
> 
> From: Christoph Hellwig <hch@lst.de>
> 
> qnx4 write support has never been fully implemented, is broken since the
> dawn of time and hasn't been actively developed since before git history
> started.
> 
> Instead of letting it further bitrot and complicate API transition (like
> the new truncate code) remove it.

Your email client mangles the patch in mysterious ways.  I suggest that
you email it to yourself and check that it applies.

