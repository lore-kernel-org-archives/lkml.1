Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbZFJH02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbZFJH02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 03:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbZFJH0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 03:26:21 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:41730 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbZFJH0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 03:26:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H++jyv6XkrI2pfPdxpYjBknQHIvQjFlXMz90Og491FxvHRcSId5iHERrlIOy7UaESX
         wlMesxI/sYrXfAQVt5CxYR/CNkWaBH3ZI7uY2ToOdmFj9+g5ov5vx5fNGzGrXKQERBuP
         VuLVbBod2DmQpdS+MjiQ7RkCiU5bMB8sXo7vQ=
Date: Wed, 10 Jun 2009 09:26:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH RESEND] ftrace: change the export format of
	trace_kfree_skb()
Message-ID: <20090610072618.GA6016@nowhere>
References: <4A2DF91F.7030906@cn.fujitsu.com> <20090609182730.GA6057@nowhere> <4A2F0F1D.7010101@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2F0F1D.7010101@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 09:40:45AM +0800, Xiao Guangrong wrote:
> 
> 
> Frederic Weisbecker wrote:
> 
> > 
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > Would you also be interested in adding the conversion from raw numeric protocol
> > to its name defined in include/linux/if_ether.h
> > 
> Hi Frederic:
> 
> OK, I'll do it.


Thanks!


> 
> > I guess __print_flags() can be used for that.
> > 
> 
> Thanks for you suggestion.
> IMHO, __print_symbolic() is more suitable for this. :-)


Heh, indeed :)

 
> > Thanks,
> > Frederic.
> > 
> > 
>  
> > 

