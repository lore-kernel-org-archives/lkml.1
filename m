Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbZFOHPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbZFOHPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 03:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbZFOHPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 03:15:37 -0400
Received: from mail-px0-f189.google.com ([209.85.216.189]:35910 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbZFOHPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 03:15:36 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2009 03:15:36 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FYsK2tzuIr+KEJMnUBIw/cyy4nLI2IyxgJFqZDaC0s3ev8F4ygevh3s3hlj7oUva3C
         HXpLwX9A4Vhpj4w7HTFnVknhAz48JW0iCrZWon5PhXC3rxQERpkADlm9USR4y1n09pvw
         k+GWzK1FPLIez+CMuyW/zmwGwIGue+g9BkJK0=
Date: Mon, 15 Jun 2009 15:11:25 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: memconsole: a virtual console to record the Oops message for
	debugging purpose.
Message-ID: <20090615071125.GF3544@cr0.nay.redhat.com>
References: <412e6f7f0906131829y6e0abb00j85e221f92ab439d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <412e6f7f0906131829y6e0abb00j85e221f92ab439d2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 09:29:48AM +0800, Changli Gao wrote:
>
>the following code is appended to the file mm/bootmem.c


Why not a patch?

Your code is a kernel module, why do you append it into
a non-module source file?
