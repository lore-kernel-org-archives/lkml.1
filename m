Return-Path: <linux-kernel-owner+w=401wt.eu-S1760388AbZAJBoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388AbZAJBoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 20:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbZAJBoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 20:44:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640AbZAJBoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 20:44:13 -0500
Date: Fri, 9 Jan 2009 17:43:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, a.beregalov@gmail.com
Subject: Re: + irda-fix-incomplete-conversation-to-internal-stats.patch
 added to -mm tree
Message-Id: <20090109174341.25d5527a.akpm@linux-foundation.org>
In-Reply-To: <20090109.171201.80737529.davem@davemloft.net>
References: <200901100023.n0A0N9st031030@imap1.linux-foundation.org>
	<20090109.171201.80737529.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Jan 2009 17:12:01 -0800 (PST) David Miller <davem@davemloft.net> wrote:

> From: akpm@linux-foundation.org
> Date: Fri, 09 Jan 2009 16:23:09 -0800
> 
> > Subject: irda: fix incomplete conversation to internal stats
> > From: Alexander Beregalov <a.beregalov@gmail.com>
> > 
> > Fix for commit af0490810c (irda: convert to internal stats)
> > 
> > Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> Andrew, this is already in the net-2.6 GIT tree, so you can safely
> toss this.

I added it so I could compile my stuff.

> commit 35a2f9993e1bef0d09c3d737aef784caaa888b48
> Author: Alexander Beregalov <a.beregalov@gmail.com>
> Date:   Thu Jan 8 16:42:08 2009 -0800
> 
>     irda: fix incomplete conversation to internal stats
>     
>     Fix for commit af0490810c (irda: convert to internal stats)
>     
>     Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
