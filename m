Return-Path: <linux-kernel-owner+w=401wt.eu-S1759063AbZFYKrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbZFYKrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 06:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbZFYKq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 06:46:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:21845 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbZFYKqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 06:46:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ppWXxZj5QF3BjNxVaY+FsH6uOo43ScfuUD0rVDUP7nVGkuja0O885Iiswy/WqVvzOK
         j8lxFZg5vXvj2j2D9Zjli1yFVKgu9CrLgi8t1nOnRue1xTHskJcN9bXmE6Yq3Os585WE
         MXNSU3K0mrMZr3NrXWOaZ8wepVQEzV213oX+o=
Date: Thu, 25 Jun 2009 18:49:01 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Boaz Harrosh <bharrosh@panasas.com>, Paul Menage <menage@google.com>,
       akpm@linux-foundation.org, jdike@addtoit.com,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH] UML: Fix some apparent bitrot
Message-ID: <20090625104901.GG6374@cr0.nay.redhat.com>
References: <20090620005524.25582.69677.stgit@menage.mtv.corp.google.com> <4A3F4448.30502@panasas.com> <20090622085735.GB6499@cr0.nay.redhat.com> <20090622205226.fee30ba8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090622205226.fee30ba8.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, Jun 22, 2009 at 08:52:26PM +1000, Stephen Rothwell wrote:
>Hi Amerigo,
>
>On Mon, 22 Jun 2009 16:57:35 +0800 Amerigo Wang <xiyou.wangcong@gmail.com> wrote:
>>
>> Stephan, could you please also do compiling tests for UML in your -next tree?
>> 
>> Thanks!
>
>I would be happy to do this, all I need is for someone to tell me how to
>do this given we have PowerPC hosts so our X86 compilers are cross
>compilers.

make ARCH=um SUBARCH=ppc? Or something similar...

Thanks.

