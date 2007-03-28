Return-Path: <linux-kernel-owner+w=401wt.eu-S1751224AbXC1AvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbXC1AvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 20:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbXC1AvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 20:51:21 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:35646 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbXC1AvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 20:51:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=ix6DyZPSVC0WggngS+UkeS9HnpnWggB9v6LQh8QUz+w7jrgAiHzpXu7cqyTEAIgD0d24ido1MrEg8/JkOpja5qp/zHMnZmcAu8zYEkotWRmBMhFl1B4eqetj5ks8RqVdun+mh26E+kqPGdzIa5jyiaeDBmmoZI/WePmOemDq2OM=
Date: Tue, 27 Mar 2007 19:50:59 -0500
From: Jay Cliburn <jcliburn@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Jose Alberto Reguero <jareguero@telefonica.net>,
       Chris Snook <csnook@redhat.com>
Subject: Re: 2.6.21-rc5: known regressions with patches
Message-ID: <20070327195059.7261facc@osprey.hogchain.net>
In-Reply-To: <20070327230024.GJ16477@stusta.de>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
	<20070327230024.GJ16477@stusta.de>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007 01:00:24 +0200
Adrian Bunk <bunk@stusta.de> wrote:

> Subject    : atl1 net driver: problem with sockets
> References : http://lkml.org/lkml/2007/3/21/248
> Submitter  : Jose Alberto Reguero <jareguero@telefonica.net>
> Patch      : http://marc.info/?l=linux-netdev&m=117502041808665&w=2
> Status     : patch available

Patch submitted to netdev.  http://lkml.org/lkml/2007/3/27/321

Best,
Jay
