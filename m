Return-Path: <linux-kernel-owner+w=401wt.eu-S1760062AbXGBOZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062AbXGBOZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbXGBOZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:25:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:55332 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbXGBOZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:25:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GL8DGEXFI/OOxh+k4t3IXebfsTTzIcv65TcY4FJU2M4i0jWap68jwqgMU3VnRqDz+uiYFIUEgNWdg3MbeAfn7qxUGTyrgWw6tjmFOtvRFaBz3wIzohWI2Wtb2r0mjQBfAdbbfc9H5/QA66UNMqHEJhc+lWhP5GFSuPia7ZQcR80=
Message-ID: <81b0412b0707020725t2e95b972y2d52ec902a31a616@mail.gmail.com>
Date: Mon, 2 Jul 2007 16:25:37 +0200
From: "Alex Riesen" <raa.lkml@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: why does git perpetually complain about include/asm-blackfin/macros.h?
Cc: "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Git Mailing List" <git@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <81b0412b0707020722q25e8eb41t456e7316fe4a7b40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0707020800010.1972@localhost.localdomain>
	 <4688EF9B.8020405@garzik.org>
	 <9a8748490707020658t5e6542ag6edb435dbc4499ab@mail.gmail.com>
	 <4689073D.1020802@garzik.org>
	 <81b0412b0707020722q25e8eb41t456e7316fe4a7b40@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/07, Alex Riesen <raa.lkml@gmail.com> wrote:
> In that second case I can only suspect that all your branches point
> at the same commit, which is just before the one the file was removed
> in...

_Not_ the same. Just some commit before the file was removed, of course.
