Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591AbXJZK4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbXJZK4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 06:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbXJZKz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 06:55:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39696
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751109AbXJZKz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 06:55:57 -0400
Date: Fri, 26 Oct 2007 03:55:59 -0700 (PDT)
Message-Id: <20071026.035559.218058202.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: bunk@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fs/proc/proc_net.c: make a struct static
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1bqao8jgx.fsf@ebiederm.dsl.xmission.com>
References: <20071024162329.GQ30533@stusta.de>
	<m1bqao8jgx.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 24 Oct 2007 12:18:22 -0600

> Adrian Bunk <bunk@kernel.org> writes:
> 
> > Struct proc_net_ns_ops can become static.
> >
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Applied, thanks everyone.

> Don't have a clue why I didn't make it static originally.

:-)
