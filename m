Return-Path: <linux-kernel-owner+w=401wt.eu-S1758080AbYHEAXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080AbYHEAXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 20:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbYHEAWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 20:22:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753937AbYHEAWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 20:22:51 -0400
Date: Mon, 4 Aug 2008 17:22:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mgross@linux.intel.com
Cc: lkml <linux-kernel@vger.kernel.org>, richard@hughsie.com
Subject: Re: spell check patch to pm_qos_params.c
Message-Id: <20080804172248.c0d18b8f.akpm@linux-foundation.org>
In-Reply-To: <20080801175245.GC23227@linux.intel.com>
References: <20080801175245.GC23227@linux.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008 10:52:45 -0700 mark gross <mgross@linux.intel.com> wrote:

> This is a documentation clean up patch form Richard Hughes.
> 
> With a minor tweak to clarify units for kbs.
> 
> Please apply.
> 
> thanks,
> 
> --mgross
> 
> 
> Signed-off-by: mark gross <mgross@linux.intel.com>

The way in which to signify that another person authored a patch is to
put that person's From: line right at the start of the changelog.  I
have made that change.

Also, we'd prefer to include Richard's signed-off-by: in the patch please,
although I tend to let that slide for small fixes.
