Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbYIEALZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbYIEALZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 20:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYIEALR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 20:11:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbYIEALQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 20:11:16 -0400
Date: Thu, 4 Sep 2008 17:10:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Jones <pjones@redhat.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efifb/imacfb consolidation + hardware support
Message-Id: <20080904171006.3698819b.akpm@linux-foundation.org>
In-Reply-To: <48C001EC.3040205@redhat.com>
References: <48C001EC.3040205@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> User-Agent: Thunderbird 2.0.0.14 (X11/20080501)

uh-oh.

On Thu, 04 Sep 2008 11:42:36 -0400
Peter Jones <pjones@redhat.com> wrote:

> Hi.  Below is a patch that removes imacfb entirely, merging its DMI
> table into the (otherwise very similar) efifb driver.  This also adds
> hardware support for many of the newer Intel Apple hardware.  This has
> been fairly well tested; we've been shipping it in Fedora for some time.
> 

The patch was space-stuffed.  I fixed that.  Please see
Documentation/email-clients.txt to fix it.

Please send a Signed-off-by: for this change.
