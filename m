Return-Path: <linux-kernel-owner+w=401wt.eu-S933769AbYDVN7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769AbYDVN7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933670AbYDVN7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:59:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933663AbYDVN7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:59:22 -0400
Date: Tue, 22 Apr 2008 06:58:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: sfr@canb.auug.org.au, philipp.zabel@gmail.com, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: linux-next: Linus' tree build breakage
Message-Id: <20080422065849.d0b248e8.akpm@linux-foundation.org>
In-Reply-To: <20080422073622.GB22955@flint.arm.linux.org.uk>
References: <20080422103111.e1d38371.sfr@canb.auug.org.au>
	<20080422073622.GB22955@flint.arm.linux.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 22 Apr 2008 08:36:22 +0100 Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> linux-next will not give me anything which -mm isn't giving me.  As I
> said in the discussion, linux-next value is _very_ small for me.

Putting arm into linux-next means that Stephen (and git) handle the merges
rather than having me (and not-git) do it.  Which helps me.

I expect that linux-next will get a lot more cross-compilation testing than
-mm.  Which helps you.
